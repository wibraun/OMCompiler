/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-2014, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF THE BSD NEW LICENSE OR THE
 * GPL VERSION 3 LICENSE OR THE OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the OSMC (Open Source Modelica Consortium)
 * Public License (OSMC-PL) are obtained from OSMC, either from the above
 * address, from the URLs: http://www.openmodelica.org or
 * http://www.ida.liu.se/projects/OpenModelica, and in the OpenModelica
 * distribution. GNU version 3 is obtained from:
 * http://www.gnu.org/copyleft/gpl.html. The New BSD License is obtained from:
 * http://www.opensource.org/licenses/BSD-3-Clause.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, EXCEPT AS
 * EXPRESSLY SET FORTH IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE
 * CONDITIONS OF OSMC-PL.
 *
 */

/*! \file linearSolverNicslu.c
 */

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
#include "linearSolverNicslu.h"
#include "nicslu/nicslu.h"


static void printMatrixCSC(int* Ap, int* Ai, double* Ax, int n);
static void printMatrixCSR(int* Ap, int* Ai, double* Ax, int n);

/*! \fn allocate memory for linear system solver Klu
 *
 */
int
allocateNicsluData(unsigned int n, unsigned int nz, void** voiddata)
{
  DATA_NICSLU* data = (DATA_NICSLU*) malloc(sizeof(DATA_NICSLU));
  assertStreamPrint(NULL, 0 != data, "Could not allocate data for linear solver Nicslu.");

  data->nicslu = (SNicsLU *)malloc(sizeof(SNicsLU));
  NicsLU_Initialize(data->nicslu);

  data->n = n;
  data->nnz = nz;

  data->ap = (unsigned int*) calloc((n+1),sizeof(unsigned int));

  data->ai = (unsigned int*) calloc(nz,sizeof(unsigned int));
  data->ax = (double*) calloc(nz,sizeof(double));

  data->x = (double*)calloc(n+n, sizeof(double));

  data->work = (double*) calloc(n,sizeof(double));

  data->numberSolving = 0;

  *voiddata = (void*)data;

  return 0;
}


/*! \fn free memory for linear system solver Nicslu
 *
 */
int
freeNicsluData(void **voiddata)
{
  TRACE_PUSH

  DATA_NICSLU* data = (DATA_NICSLU*) *voiddata;
  NicsLU_Destroy(data->nicslu);

  free(data->nicslu);
  free(data->ai);
  free(data->ax);
  free(data->ap);
  free(data->x);

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
static
int getAnalyticalJacobian(DATA* data, threadData_t *threadData, int sysNumber)
{
  int i,ii,j,k,l;
  LINEAR_SYSTEM_DATA* systemData = &(((DATA*)data)->simulationInfo->linearSystemData[sysNumber]);

  const int index = systemData->jacobianIndex;
  int nth = 0;
  int nnz = data->simulationInfo->analyticJacobians[index].sparsePattern.numberOfNoneZeros;

  for(i=0; i < data->simulationInfo->analyticJacobians[index].sizeRows; i++)
  {
    data->simulationInfo->analyticJacobians[index].seedVars[i] = 1;

    ((systemData->analyticalJacobianColumn))(data, threadData);

    for(j = 0; j < data->simulationInfo->analyticJacobians[index].sizeCols; j++)
    {
      if(data->simulationInfo->analyticJacobians[index].seedVars[j] == 1)
      {
        ii = data->simulationInfo->analyticJacobians[index].sparsePattern.leadindex[j];
        while(ii < data->simulationInfo->analyticJacobians[index].sparsePattern.leadindex[j+1])
        {
          l  = data->simulationInfo->analyticJacobians[index].sparsePattern.index[ii];
          systemData->setAElement(i, l, -data->simulationInfo->analyticJacobians[index].resultVars[l], nth, (void*) systemData, threadData);
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
 *
 */
static int residual_wrapper(double* x, double* f, void** data, int sysNumber)
{
  int iflag = 0;

  (*((DATA*)data[0])->simulationInfo->linearSystemData[sysNumber].residualFunc)(data, x, f, &iflag);
  return 0;
}

/*! \fn solve linear system with Klu method
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
  void *dataAndThreadData[2] = {data, threadData};
  LINEAR_SYSTEM_DATA* systemData = &(data->simulationInfo->linearSystemData[sysNumber]);
  DATA_NICSLU* solverData = (DATA_NICSLU*)systemData->solverData[0];

  int i, j, status = 0, success = 0, n = systemData->size, eqSystemNumber = systemData->equationIndex, indexes[2] = {1,eqSystemNumber};
  double tmpJacEvalTime;
  int reuseMatrixJac = (data->simulationInfo->currentContext == CONTEXT_SYM_JACOBIAN && data->simulationInfo->currentJacobianEval > 0);

  infoStreamPrintWithEquationIndexes(LOG_LS, 0, indexes, "Start solving Linear System %d (size %d) at time %g with Nicslu Solver",
   eqSystemNumber, (int) systemData->size,
   data->localData[0]->timeValue);

  rt_ext_tp_tick(&(solverData->timeClock));
  if (0 == systemData->method)
  {
    if (!reuseMatrixJac){
      /* set A matrix */
      solverData->ap[0] = 0;
      systemData->setA(data, threadData, systemData);
      solverData->ap[solverData->n] = solverData->nnz;
    }

    /* set b vector */
    systemData->setb(data, threadData, systemData);
  } else {

    if (!reuseMatrixJac){
      solverData->ap[0] = 0;
      /* calculate jacobian -> matrix A*/
      if(systemData->jacobianIndex != -1){
        getAnalyticalJacobian(data, threadData, sysNumber);
      } else {
        assertStreamPrint(threadData, 1, "jacobian function pointer is invalid" );
      }
      solverData->ap[solverData->n] = solverData->nnz;
    }

    /* calculate vector b (rhs) */
    memcpy(solverData->work, systemData->x, sizeof(double)*solverData->n);
    residual_wrapper(solverData->work, systemData->b, dataAndThreadData, sysNumber);
  }
  NicsLU_CreateMatrix(solverData->nicslu,solverData->n,solverData->nnz,solverData->ax,solverData->ai,solverData->ap);
  solverData->nicslu->cfgf[0] = 1e-3;

  tmpJacEvalTime = rt_ext_tp_tock(&(solverData->timeClock));
  systemData->jacobianTime += tmpJacEvalTime;
  infoStreamPrint(LOG_LS_V, 0, "###  %f  time to set Matrix A and vector b.", tmpJacEvalTime);

  if (ACTIVE_STREAM(LOG_LS_V))
  {
    infoStreamPrint(LOG_LS_V, 1, "Old solution x:");
    for(i = 0; i < solverData->n; ++i)
      infoStreamPrint(LOG_LS_V, 0, "[%d] %s = %g", i+1, modelInfoGetEquation(&data->modelData->modelDataXml,eqSystemNumber).vars[i], systemData->x[i]);
    messageClose(LOG_LS_V);

    infoStreamPrint(LOG_LS_V, 1, "Matrix A n_rows = %d", solverData->n);
    for (i=0; i<solverData->n; i++){
      infoStreamPrint(LOG_LS_V, 0, "%d. Ap => %d -> %d", i, solverData->ap[i], solverData->ap[i+1]);
      for (j=solverData->ap[i]; j<solverData->ap[i+1]; j++){
        infoStreamPrint(LOG_LS_V, 0, "A[%d,%d] = %f", i, solverData->ai[j], solverData->ax[j]);
      }
    }
    messageClose(LOG_LS_V);

    for (i=0; i<solverData->n; i++)
      infoStreamPrint(LOG_LS_V, 0, "b[%d] = %e", i, systemData->b[i]);
  }
  rt_ext_tp_tick(&(solverData->timeClock));


  /* symbolic pre-ordering of A to reduce fill-in of L and U */
  if (0 == solverData->numberSolving)
  {
    NicsLU_Analyze(solverData->nicslu);
  }

  NicsLU_Factorize(solverData->nicslu);
  NicsLU_ReFactorize(solverData->nicslu, solverData->ax);
  NicsLU_Solve(solverData->nicslu,solverData->x);

  infoStreamPrint(LOG_LS_V, 0, "Solve System: %f", rt_ext_tp_tock(&(solverData->timeClock)));

  /* print solution */
  if (1 == success){

    if (1 == systemData->method){
      /* take the solution */
      for(i = 0; i < solverData->n; ++i)
        systemData->x[i] += systemData->b[i];

      /* update inner equations */
      residual_wrapper(systemData->x, solverData->work, dataAndThreadData, sysNumber);
    } else {
      /* the solution is automatically in x */
      memcpy(systemData->x, systemData->b, sizeof(double)*systemData->size);
    }

    if (ACTIVE_STREAM(LOG_LS_V))
    {
      infoStreamPrint(LOG_LS_V, 1, "Solution x:");
      infoStreamPrint(LOG_LS_V, 0, "System %d numVars %d.", eqSystemNumber, modelInfoGetEquation(&data->modelData->modelDataXml,eqSystemNumber).numVar);

      for(i = 0; i < systemData->size; ++i)
        infoStreamPrint(LOG_LS_V, 0, "[%d] %s = %g", i+1, modelInfoGetEquation(&data->modelData->modelDataXml,eqSystemNumber).vars[i], systemData->x[i]);

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

  return success;
}

static
void printMatrixCSC(int* Ap, int* Ai, double* Ax, int n)
{
  int i, j, k, l;

  char **buffer = (char**)malloc(sizeof(char*)*n);
  for (l=0; l<n; l++)
  {
    buffer[l] = (char*)malloc(sizeof(char)*n*20);
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
  char *buffer = (char*)malloc(sizeof(char)*n*15);
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

