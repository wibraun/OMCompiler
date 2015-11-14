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

/*! \file omc_jacobian.c
 */

#include <pthread.h>
#include <string.h> /* memcpy */
#include <math.h>

#include "util/omc_error.h"

#include "simulation_data.h"
#include "omc_jacobian.h"
#include "omc_math.h"


int getSymbolicalJacobianSer(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*),  double* jac);
int getSymbolicalJacobianPar(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*),  double* jac);


/*! \fn getSymbolicalJacobian
 *
 *  public function calculate symbolic jacobian in serial or in parallel
 *
 *  \param [ref] [data]
 *  \param [out] [jac]
 *
 *  \author wbraun
 *
 */
int getSymbolicalJacobian(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*),  double* jac)
{
  int retVal;
  if (data->simulationInfo->parJacEval)
  {
    retVal = getSymbolicalJacobianPar(data, threadData, analyticJacobian, analyticalJacobianColumn, jac);
  }
  else
  {
    retVal = getSymbolicalJacobianSer(data, threadData, analyticJacobian, analyticalJacobianColumn, jac);
  }

  return retVal;
}

/*! \fn getSymbolicalJacobianSer
 *
 *  function calculates analytical jacobian
 *
 *  \param [ref] [data]
 *  \param [out] [jac]
 *
 *  \author wbraun
 *
 */
int getSymbolicalJacobianSer(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*),  double* jac)
{
  int i,j,k,l,ii;
  //rtclock_t timeClock;             /* time clock */

  for(i=0; i < analyticJacobian->sparsePattern.maxColors; i++)
  {
    /* activate seed variable for the corresponding color */
    for(ii=0; ii < analyticJacobian->sizeCols; ii++)
      if(analyticJacobian->sparsePattern.colorCols[ii]-1 == i)
        analyticJacobian->seedVars[ii] = 1;

    //rt_ext_tp_tick(&(timeClock));
    analyticalJacobianColumn(data, threadData, analyticJacobian);
    //infoStreamPrint(LOG_JAC, 0, "###  %f run analyticalJacobianColumn %d", rt_ext_tp_tock(&(timeClock)), i);

    for(j = 0; j < analyticJacobian->sizeCols; j++)
    {
      if(analyticJacobian->seedVars[j] == 1)
      {
        if(j==0)
          ii = 0;
        else
          ii = analyticJacobian->sparsePattern.leadindex[j-1];
        while(ii < analyticJacobian->sparsePattern.leadindex[j])
        {
          l  = analyticJacobian->sparsePattern.index[ii];
          k  = j*analyticJacobian->sizeRows + l;
          jac[k] = analyticJacobian->resultVars[l];
          ii++;
        };
      }
      /* de-activate seed variable for the corresponding color */
      if(analyticJacobian->sparsePattern.colorCols[j]-1 == i)
        analyticJacobian->seedVars[j] = 0;
    }
  }

  return 0;
}
typedef struct ARGS_PARJAC
{
  int tid;
  DATA* data;
  threadData_t *threadData;
  SYMBOLIC_JAC_PARDATA* symJacParData;
  int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*);
  unsigned int numberOfColumns;
  unsigned int* columns;
  unsigned int startingColumn;
}ARGS_PARJAC;


SYMBOLIC_JAC_PARDATA* allocateSymbolicJacParData(unsigned int numProcess, unsigned int sizeSeedVars, unsigned int sizeTmpVars, unsigned int sizeResultVars, SPARSE_PATTERN* sparsePattern)
{
  SYMBOLIC_JAC_PARDATA* symJacParData = (SYMBOLIC_JAC_PARDATA*)malloc(sizeof(SYMBOLIC_JAC_PARDATA));
  unsigned int i, j, before = 0, numCols, rest;

  symJacParData->numProcess = numProcess;
  symJacParData->sizeSeedVars = sizeSeedVars;
  symJacParData->sizeTmpVars = sizeTmpVars;
  symJacParData->sizeResultVars = sizeResultVars;

  symJacParData->seedVars = (double*)calloc(sparsePattern->maxColors*sizeSeedVars, sizeof(double));
  symJacParData->tmpVars = (double*)malloc(numProcess*sizeTmpVars*sizeof(double));
  symJacParData->resultVars = (double*)malloc(sparsePattern->maxColors*sizeResultVars*sizeof(double));

  symJacParData->tid = (pthread_t*)malloc(sizeof(pthread_t)*symJacParData->numProcess);
  symJacParData->anaJacs = (ANALYTIC_JACOBIAN*)malloc(sizeof(ANALYTIC_JACOBIAN)*symJacParData->numProcess);
  symJacParData->parFuncArgs = (ARGS_PARJAC*)malloc(sizeof(ARGS_PARJAC)*symJacParData->numProcess);

  infoStreamPrint(LOG_JAC, 1, "Allocate memory for %d columns distribute on %d processes.", sparsePattern->maxColors, symJacParData->numProcess);
  numCols = floor(sparsePattern->maxColors/numProcess);
  infoStreamPrint(LOG_JAC, 0, "numCols %d.", numCols);
  rest = sparsePattern->maxColors % numProcess;
  infoStreamPrint(LOG_JAC, 0, "rest %d.", rest);
  for(i = 0; i < symJacParData->numProcess; ++i)
  {
    ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].numberOfColumns = numCols;
    if (i < rest)
    {
      ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].numberOfColumns++;
    }
    ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].startingColumn = before;
    before += ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].numberOfColumns;

    infoStreamPrint(LOG_JAC, 0, "create func ptr for thread %d with %d columns starting with %d.", i, ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].numberOfColumns, ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].startingColumn);
    ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].columns = (unsigned int*)malloc(((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].numberOfColumns*sizeof(unsigned int));
    for(j = 0; j < ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].numberOfColumns; ++j)
    {
      ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].columns[j] = ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].startingColumn+j;
      infoStreamPrint(LOG_JAC, 0, "column %d", ((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].columns[j]);
    }
  }
  messageClose(LOG_JAC);

  /* write seed vector */
  for(i=1; i <= sparsePattern->maxColors; ++i)
  {
    /* activate seed variable for the corresponding color */
    for(j=0; j < sizeSeedVars; ++j)
    {
      if(sparsePattern->colorCols[j] == i)
      {
        symJacParData->seedVars[(i-1)*sizeSeedVars + j] = 1;
      }
    }
  }

  return symJacParData;
}

void freeSymbolicJacParData(SYMBOLIC_JAC_PARDATA* symJacParData)
{
  int i;

  free(symJacParData->seedVars);
  free(symJacParData->tmpVars);
  free(symJacParData->resultVars);

  free(symJacParData->tid);

  for(i = 0; i < symJacParData->numProcess; ++i)
    free(((ARGS_PARJAC*)symJacParData->parFuncArgs)[i].columns);

  free(symJacParData->parFuncArgs);
  free(symJacParData->anaJacs);

  free(symJacParData);
}

void* analyticalJacobianColumnPar(void* parArgs)
{
  ARGS_PARJAC* parFuncArgs =  (ARGS_PARJAC*) parArgs;
  DATA* data = parFuncArgs->data;
  threadData_t *threadData  = parFuncArgs->threadData;
  SYMBOLIC_JAC_PARDATA* symJacParData = parFuncArgs->symJacParData;
  ANALYTIC_JACOBIAN *anaJacsPtr, *anaJacs = (ANALYTIC_JACOBIAN*) symJacParData->anaJacs;
  int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*)  = parFuncArgs->analyticalJacobianColumn;
  int i, j;
  //rtclock_t timeClock;             /* time clock */

  anaJacsPtr = &anaJacs[parFuncArgs->tid];
  anaJacsPtr->tmpVars = symJacParData->tmpVars + parFuncArgs->tid*symJacParData->sizeTmpVars;
  for(i = 0; i < parFuncArgs->numberOfColumns; ++i)
  {
    /* prepare for each thread a object of ANALYTIC_JACOBIAN  */
    j = parFuncArgs->startingColumn+i;
    anaJacsPtr->sizeCols = symJacParData->sizeSeedVars;
    anaJacsPtr->sizeTmpVars = symJacParData->sizeTmpVars;
    anaJacsPtr->sizeRows = symJacParData->sizeResultVars;
    anaJacsPtr->seedVars = symJacParData->seedVars + j*anaJacsPtr->sizeCols;
    anaJacsPtr->resultVars = symJacParData->resultVars + j*anaJacsPtr->sizeRows;

    //rt_ext_tp_tick(&(timeClock));
    analyticalJacobianColumn(data, threadData, anaJacsPtr);
    //infoStreamPrint(LOG_JAC, 0, "###  %f run analyticalJacobianColumn %d for thread %d.", rt_ext_tp_tock(&(timeClock)), i, parFuncArgs->tid);
  }
  pthread_exit(NULL);
}

/*! \fn getAnalyticalJacobian
 *
 *  function calculates analytical jacobian
 *
 *  \param [ref] [data]
 *  \param [out] [jac]
 *
 *  \author wbraun
 *
 */
int getSymbolicalJacobianPar(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN*),  double* jac)
{
  SYMBOLIC_JAC_PARDATA* symJacParData = analyticJacobian->parJacobian;
  pthread_t* tid = (pthread_t*) symJacParData->tid;
  ARGS_PARJAC *parFuncPtr, *parFuncArgs = (ARGS_PARJAC*) symJacParData->parFuncArgs;
  pthread_attr_t attr;
  int i,j,k,l,ii, colorCol;
  rtclock_t timeClock;             /* time clock */

  rt_ext_tp_tick(&(timeClock));
/*
  for(i = 0; i < analyticJacobian->sparsePattern.maxColors; i++)
  {
    //infoStreamPrint(LOG_JAC, 0, " Column %d start %d ends %d\n", i, i*analyticJacobian->sizeCols, i*analyticJacobian->sizeCols+analyticJacobian->sizeCols);
    for(j = 0; j < analyticJacobian->sizeCols; j++){
      if(symJacParData->seedVars[i*analyticJacobian->sizeCols+j] == 1)
        infoStreamPrint(LOG_JAC, 0, " color %d -> seed %d\n", i+1, j);
    }
  }

 for(i=0; i < analyticJacobian->sizeCols; i++){
    parFuncPtr = &parFuncArgs[i];
    parFuncPtr->seedVars = symJacParData->seedVars + i*analyticJacobian->sizeCols;
    infoStreamPrint(LOG_JAC, 0, " Start %d\n", i);
    for(ii=0; ii < analyticJacobian->sizeCols; ii++)
      infoStreamPrint(LOG_JAC, 0, " -- seedVars %d = %f\n", ii, parFuncPtr->seedVars[ii]);
 }
*/

  /* Initialize and set thread detached attribute */
  pthread_attr_init(&attr);
  //pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_UNDETACHED);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

  for(i=0; i < symJacParData->numProcess; i++)
  {
    /* prepare for each thread an function pointer */
    parFuncPtr = &parFuncArgs[i];
    parFuncPtr->tid = i;
    parFuncPtr->data = data;
    parFuncPtr->threadData = threadData;
    parFuncPtr->symJacParData = symJacParData;
    parFuncPtr->analyticalJacobianColumn = analyticalJacobianColumn;
    //infoStreamPrint(LOG_JAC, 0, "Launch thread %d with %d columns starting with %d.", i, parFuncPtr->numberOfColumns, parFuncPtr->startingColumn);
    pthread_create(&tid[i], &attr, analyticalJacobianColumnPar, (void*) (parFuncPtr));
  }

  pthread_attr_destroy(&attr);

  for(i=0; i < symJacParData->numProcess; i++)
  {
    pthread_join(tid[i], NULL);
  }

  for(i=0; i < analyticJacobian->sparsePattern.maxColors; i++)
    for(ii=0; ii < analyticJacobian->sizeRows; ii++)
      infoStreamPrint(LOG_JAC, 0, " resultVars %d = %f", i*analyticJacobian->sizeRows+ii, symJacParData->resultVars[i*analyticJacobian->sizeRows+ii]);

  for(j = 0; j < analyticJacobian->sizeCols; j++)
  {
    colorCol = analyticJacobian->sparsePattern.colorCols[j]-1;
    if(j==0)
      ii = 0;
    else
      ii = analyticJacobian->sparsePattern.leadindex[j-1];
    while(ii < analyticJacobian->sparsePattern.leadindex[j])
    {
      l  = analyticJacobian->sparsePattern.index[ii];
      k  = j*analyticJacobian->sizeCols + l;
      //infoStreamPrint(LOG_JAC, 0, " %d. resultVars %d = %f (l = %d, k = %d)\n", k, colorCol*analyticJacobian->sparsePattern.maxColors+l, symJacParData->resultVars[colorCol*analyticJacobian->sparsePattern.maxColors+l], l, k);
      jac[k] = symJacParData->resultVars[colorCol*analyticJacobian->sizeRows+l];
      ii++;
    };
  }

  return 0;
}
