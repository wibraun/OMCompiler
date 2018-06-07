#include "omc_config.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "simulation_data.h"
#include "simulation/simulation_info_json.h"
#include "util/omc_error.h"
#include "util/varinfo.h"
#include "model_help.h"

#include "linearSystem.h"
#include "nicslu.h"

//INDEX DER MATRIX CSR oder CSC Mode!!!

/*! \fn allocate memory for linear system solver Nicslu
*
*/

int allocateNicsluData(unsigned int n, unsigned int nnz,void** voiddata)
{
	/*Datenstruktur für NICSLU erzeugen*/
	DATA_NICSLU* data = (DATA_NICSLU*)malloc(sizeof(DATA_NISLU));
	assertStreamPrint(NULL, 0 != data, "Could not allocate data for linear solver Nicslu.");

	/*Speicher für SNicsLU reservieren*/
	data->nicslu= (SNicsLU *)malloc(sizeof(SNicsLU));
	/*Initialisieren der Datenstruktur siehe Demos.c*/
	NicsLU_Initialize(data->nicslu);

	data->n = n;
	data->nnz = nnz;

	/*Benötigte Werte für weiteren Verlauf*/
	data->ax = (double*)calloc(nnz, sizeof(double));
	data->ai = (unsigned int*)calloc(nnz, sizeof(unsigned int));
	data->ap = (unsigned int*)calloc((n + 1), sizeof(unsigned int));

	data->x = (double*)calloc(n+n, sizeof(double));

	/*Kommt noch aus KLU*/
	data->work = (double*)calloc(n, sizeof(double));
	/* Solver Nummer ebenfalls aus KLU*/
	data->numberSolving = 0;

	*voiddata = (void*)data;

	return 0;
}
/*! \fn free memory for linear system solver Nicslu*/
int freeNicsluData(void **voiddata)
{
	TRACE_PUSH

		DATA_NICSLU* data = (DATA_NICSLU*)*voiddata;

	NicsLU_Destroy(data->nicslu);

	free(data->nicslu); //Nicht sicher
	free(data->ax);
	free(data->ai);
	free(data->ap);
	free(data->x);
	free(data->b);

	free(data->work);



	TRACE_POP

		return 0;
}


/*! \fn getAnalyticalJacobian
*
*  function calculates analytical jacobian
*
*  \param [ref] [data]
*  \param [in]  [sysNumber]
*
*  \author wbraun
*
*/


//Hier keine Veränderung vorgenommen
static
int getAnalyticalJacobian(DATA* data, threadData_t *threadData, int sysNumber)
{
	int i, ii, j, k, l;
	LINEAR_SYSTEM_DATA* systemData = &(((DATA*)data)->simulationInfo->linearSystemData[sysNumber]);

	const int index = systemData->jacobianIndex;
	int nth = 0;
	int nnz = data->simulationInfo->analyticJacobians[index].sparsePattern.numberOfNoneZeros;

	for (i = 0; i < data->simulationInfo->analyticJacobians[index].sizeRows; i++)
	{
		data->simulationInfo->analyticJacobians[index].seedVars[i] = 1;

		((systemData->analyticalJacobianColumn))(data, threadData);

		for (j = 0; j < data->simulationInfo->analyticJacobians[index].sizeCols; j++)
		{
			if (data->simulationInfo->analyticJacobians[index].seedVars[j] == 1)
			{
				ii = data->simulationInfo->analyticJacobians[index].sparsePattern.leadindex[j];
				while (ii < data->simulationInfo->analyticJacobians[index].sparsePattern.leadindex[j + 1])
				{
					l = data->simulationInfo->analyticJacobians[index].sparsePattern.index[ii];
					systemData->setAElement(i, l, -data->simulationInfo->analyticJacobians[index].resultVars[l], nth, (void*)systemData, threadData);
					nth++;
					ii++;
				};
			}
		};

		/* de-activate seed variable for the corresponding color */
		data->simulationInfo->analyticJacobians[index].seedVars[i] = 0;
	}

	return 0;
}

/*! \fn residual_wrapper for the residual function
*			Keine Veränderung vorgenommen
*/
static int residual_wrapper(double* x, double* f, void** data, int sysNumber)
{
	int iflag = 0;

	(*((DATA*)data[0])->simulationInfo->linearSystemData[sysNumber].residualFunc)(data, x, f, &iflag);
	return 0;
}

/*! \fn solve linear system with Nicslu method
*
*  \param  [in]  [data]
*                [sysNumber] index of the corresponding linear system
*
*
* author: wbraun
*/
int
solveNicslu(DATA *data, threadData_t *threadData, int sysNumber)
{
	void *dataAndThreadData[2] = { data, threadData };
	LINEAR_SYSTEM_DATA* systemData = &(data->simulationInfo->linearSystemData[sysNumber]);
	DATA_NICSLU* solverData = (DATA_NICSLU*)systemData->solverData[0];

	int i, j, status = 0, success = 0, n = systemData->size, eqSystemNumber = systemData->equationIndex, indexes[2] = { 1,eqSystemNumber };
	double tmpJacEvalTime;
	int reuseMatrixJac = (data->simulationInfo->currentContext == CONTEXT_SYM_JACOBIAN && data->simulationInfo->currentJacobianEval > 0);

	infoStreamPrintWithEquationIndexes(LOG_LS, 0, indexes, "Start solving Linear System %d (size %d) at time %g with Nicslu Solver",
		eqSystemNumber, (int)systemData->size,
		data->localData[0]->timeValue);

	rt_ext_tp_tick(&(solverData->timeClock));

		if (0 == systemData->method) // NicsLU_ReadTripletColumnToSparse("ASIC_100k.mtx", &solverData->n, &solverData->nnz, &solverData->ax, &solverData->ai, &solverData->ap);
		{
			if (!reuseMatrixJac)
			{
				/* set A matrix */
				solverData->ap[0] = 0;
				systemData->setA(data, threadData, systemData);
				solverData->ap[solverData->n] = solverData->nnz; // n_row durch n ersetzt
			}

			/* set b vector */
			systemData->setb(data, threadData, systemData);
		}
		else {

			if (!reuseMatrixJac) {
				solverData->ap[0] = 0;
				/* calculate jacobian -> matrix A*/
				if (systemData->jacobianIndex != -1) {
					getAnalyticalJacobian(data, threadData, sysNumber);
				}
				else {
					assertStreamPrint(threadData, 1, "jacobian function pointer is invalid");
				}
				solverData->ap[solverData->n] = solverData->nnz;
			}

			/* calculate vector b (rhs) */
			memcpy(solverData->work, systemData->x, sizeof(double)*solverData->n);

			residual_wrapper(solverData->work, systemData->b, dataAndThreadData, sysNumber);
		}

	NicsLU_CreateMatrix(solverData->nicslu,solverData->n,solverData->nnz,solverData->ax,solverData->ai,solverData->ap);
	solverData->nicslu->cfgf[0] = 1e-3;//Wert?

	tmpJacEvalTime = rt_ext_tp_tock(&(solverData->timeClock));
	systemData->jacobianTime += tmpJacEvalTime;
	infoStreamPrint(LOG_LS_V, 0, "###  %f  time to set Matrix A and vector b.", tmpJacEvalTime);

	if (ACTIVE_STREAM(LOG_LS_V))
	{
		infoStreamPrint(LOG_LS_V, 1, "Old solution x:");
		for (i = 0; i < solverData->n; ++i)
			infoStreamPrint(LOG_LS_V, 0, "[%d] %s = %g", i + 1, modelInfoGetEquation(&data->modelData->modelDataXml, eqSystemNumber).vars[i], systemData->x[i]);
		messageClose(LOG_LS_V);

		infoStreamPrint(LOG_LS_V, 1, "Matrix A n_rows = %d", solverData->n);
		for (i = 0; i<solverData->n; i++) {
			infoStreamPrint(LOG_LS_V, 0, "%d. Ap => %d -> %d", i, solverData->ap[i], solverData->ap[i + 1]);
			for (j = solverData->ap[i]; j<solverData->ap[i + 1]; j++) {
				infoStreamPrint(LOG_LS_V, 0, "A[%d,%d] = %f", i, solverData->ai[j], solverData->ax[j]);
			}
		}
		messageClose(LOG_LS_V);

		for (i = 0; i<solverData->n; i++)
			infoStreamPrint(LOG_LS_V, 0, "b[%d] = %e", i, systemData->b[i]);
	}
	rt_ext_tp_tick(&(solverData->timeClock);


	/* symbolic pre-ordering of A to reduce fill-in of L and U */
	if (0 == solverData->numberSolving)
	{
		infoStreamPrint(LOG_LS_V, 0, "Perform analyze settings:\n - ordering used: %d\n - current status: %d");
		NicsLU_Analyze(solverData->nicslu);
	}

		NicsLU_Factorize(solverData->nicslu);
		NicsLU_ReFactorize(solverData->nicslu, solverData->ax); //Achtung kann numerisch instabil werden
		NicsLU_Solve(solverData->nicslu,solverData->x);

	infoStreamPrint(LOG_LS_V, 0, "Solve System: %f", rt_ext_tp_tock(&(solverData->timeClock)));

	/* print solution */
	if (1 == success) {

		if (1 == systemData->method) {
			/* take the solution */
			for (i = 0; i < solverData->n; ++i)
				systemData->x[i] += systemData->b[i];

			/* update inner equations */
			residual_wrapper(systemData->x, solverData->work, dataAndThreadData, sysNumber);
		}
		else {
			/* the solution is automatically in x */
			memcpy(systemData->x, systemData->b, sizeof(double)*systemData->size);
		}

		if (ACTIVE_STREAM(LOG_LS_V))
		{
			infoStreamPrint(LOG_LS_V, 1, "Solution x:");
			infoStreamPrint(LOG_LS_V, 0, "System %d numVars %d.", eqSystemNumber, modelInfoGetEquation(&data->modelData->modelDataXml, eqSystemNumber).numVar);

			for (i = 0; i < systemData->size; ++i)
				infoStreamPrint(LOG_LS_V, 0, "[%d] %s = %g", i + 1, modelInfoGetEquation(&data->modelData->modelDataXml, eqSystemNumber).vars[i], systemData->x[i]);

			messageClose(LOG_LS_V);
		}
	}
	else
	{
		warningStreamPrint(LOG_STDOUT, 0,
			"Failed to solve linear system of equations (no. %d) at time %f, system status %d.",
			(int)systemData->equationIndex, data->localData[0]->timeValue, status);
	}
	solverData->numberSolving += 1;
	/*stats; eventuell anders ausgeben?*/
	printf("analysis time: %.8g\n", solverData->nicslu->stat[0]);
	printf("factorization time: %.8g\n", solverDatanicslu->stat[1]);
	printf("re-factorization time: %.8g\n", solverData->nicslu->stat[2]);
	printf("substitution time: %.8g\n", solverData->nicslu->stat[3]);

	return success;
}

//Ausgabe von Matrix; vorläufig auskommentiert

/*
static
void printMatrixCSC(int* Ap, int* Ai, double* Ax, int n)
{
	int i, j, k, l;

	char **buffer = (char**)malloc(sizeof(char*)*n);
	for (l = 0; l<n; l++)
	{
		buffer[l] = (char*)malloc(sizeof(char)*n * 20);
		buffer[l][0] = 0;
	}

	k = 0;
	for (i = 0; i < n; i++)
	{
		for (j = 0; j < n; j++)
		{
			if ((k < Ap[i + 1]) && (Ai[k] == j))
			{
				sprintf(buffer[j], "%s %5g ", buffer[j], Ax[k]);
				k++;
			}
			else
			{
				sprintf(buffer[j], "%s %5g ", buffer[j], 0.0);
			}
		}
	}
	for (l = 0; l < n; l++)
	{
		infoStreamPrint(LOG_LS_V, 0, "%s", buffer[l]);
		free(buffer[l]);
	}
	free(buffer);
}

static
void printMatrixCSR(int* Ap, int* Ai, double* Ax, int n)
{
	int i, j, k;
	char *buffer = (char*)malloc(sizeof(char)*n * 15);
	k = 0;
	for (i = 0; i < n; i++)
	{
		buffer[0] = 0;
		for (j = 0; j < n; j++)
		{
			if ((k < Ap[i + 1]) && (Ai[k] == j))

			{
				sprintf(buffer, "%s %5.2g ", buffer, Ax[k]);
				k++;
			}
			else
			{
				sprintf(buffer, "%s %5.2g ", buffer, 0.0);
			}
		}
		infoStreamPrint(LOG_LS_V, 0, "%s", buffer);
	}
	free(buffer);
}

*/
