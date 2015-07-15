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

/*! \file irksco.c
 *  implicit solver for the numerical solution of ordinary differential equations (with step size control)
 *  \author kbalzereit, wbraun
 */


#include <string.h>
#include <float.h>

#include "simulation/simulation_info_xml.h"
#include "simulation/results/simulation_result.h"
#include "util/omc_error.h"
#include "util/varinfo.h"
#include "model_help.h"
#include "external_input.h"
#include "newtonIteration.h"
#include "irksco.h"

int wrapper_fvec_irksco(int* n, double* x, double* f, void* userdata, int fj);
static int refreshModel(DATA* data, double* x, double time);
void irksco_first_step(DATA* data, SOLVER_INFO* solverInfo);
int rk_imp_step(DATA* data, SOLVER_INFO* solverInfo, double* y_new);


/*! \fn allocateIrksco
 *
 *   Function allocates memory needed for implicit rk solving methods.
 *
 *   Integration methods of higher order can be used by increasing userdata->order:
 *      (1) implicit euler method
 *      (3) radauIIA method of order 3 (needs to be finished)
 *      (5) radauIIA method of order 5 (needs to be finished)
 *
 */
int allocateIrksco(SOLVER_INFO* solverInfo, int size, int zcSize)
{
  DATA_IRKSCO* userdata = (DATA_IRKSCO*) malloc(sizeof(DATA_IRKSCO));
  solverInfo->solverData = (void*) userdata;
  userdata->order = 1;

  switch (userdata->order)
  {
  case 1:
    userdata->ordersize = 1;
    break;
  case 3:
    userdata->ordersize = 2;
    break;
  case 5:
    userdata->ordersize = 3;
    break;
  default:
    userdata->ordersize = 1;
    break;
  }

  allocateNewtonData(userdata->ordersize*size, &(userdata->solverData));
  userdata->firstStep = 1;
  userdata->y0 = malloc(sizeof(double)*size);
  userdata->y05= malloc(sizeof(double)*size);
  userdata->y1 = malloc(sizeof(double)*size);
  userdata->y2 = malloc(sizeof(double)*size);
  userdata->der_x0 = malloc(sizeof(double)*size);
  userdata->radauVarsOld = malloc(sizeof(double)*size);
  userdata->radauVars = malloc(sizeof(double)*size);
  userdata->zeroCrossingValues = malloc(sizeof(double)*zcSize);
  userdata->zeroCrossingValuesOld = malloc(sizeof(double)*zcSize);

  userdata->m = malloc(sizeof(double)*size);
  userdata->n = malloc(sizeof(double)*size);

  userdata->A = malloc(sizeof(double)*userdata->ordersize*userdata->ordersize);
  userdata->Ainv = malloc(sizeof(double)*userdata->ordersize*userdata->ordersize);
  userdata->c = malloc(sizeof(double)*userdata->ordersize);
  userdata->d = malloc(sizeof(double)*userdata->ordersize);

  /* initialize stats */
  userdata->stepsDone = 0;
  userdata->evalFunctionODE = 0;
  userdata->evalJacobians = 0;

  userdata->radauStepSizeOld = 0;

  switch (userdata->order)
  {
  case 1:
    userdata->A[0] = 1;
    userdata->c[0] = 1;
    userdata->d[0] = 1;
    break;
  case 3:

    userdata->A[0] = 0.416666666666666666666666666666;
    userdata->A[1] = 0.75;
    userdata->A[2] = -0.08333333333333333333333333333;
    userdata->A[3] = 0.25;

    userdata->Ainv[0] = 1.5;
    userdata->Ainv[0] = 0.5;
    userdata->Ainv[0] = -4.5;
    userdata->Ainv[0] = 2.5;

    userdata->c[0] = 0.333333333333333333333333333333;
    userdata->c[1] = 1.0;

    userdata->d[0] = 0.0;
    userdata->d[1] = 1.0;
    break;
  case 5:
    userdata->A[0] =  0.196815477223660;
    userdata->A[1] =  0.394424314739087;
    userdata->A[2] =  0.376403062700467;
    userdata->A[3] = -0.065535425850198;
    userdata->A[4] =  0.292073411665228;
    userdata->A[5] =  0.512485826188422;
    userdata->A[6] =  0.023770974348220;
    userdata->A[7] = -0.041548752125998;
    userdata->A[8] =  0.111111111111111;

    userdata->c[0] =  0.155051025721682;
    userdata->c[1] =  0.644948974278317;
    userdata->c[2] =  1.0;

    userdata->d[0] =  0.0;
    userdata->d[1] =  0.0;
    userdata->d[2] =  1.0;
    break;
  default:
    break;
  }

  return 0;
}

/*! \fn freeIrksco
 *
 *   Memory needed for solver is set free.
 */
int freeIrksco(SOLVER_INFO* solverInfo)
{
  DATA_IRKSCO* userdata = (DATA_IRKSCO*) solverInfo->solverData;
  freeNewtonData(&(userdata->solverData));

  free(userdata->y0);
  free(userdata->y05);
  free(userdata->y1);
  free(userdata->y2);
  free(userdata->der_x0);
  free(userdata->radauVarsOld);
  free(userdata->radauVars);
  free(userdata->zeroCrossingValues);
  free(userdata->zeroCrossingValuesOld);

  return 0;
}

/*! \fn checkForZeroCrossingsIrksco
 *
 *   This function checks for ZeroCrossings.
 */
int checkForZeroCrossingsIrksco(DATA* data, DATA_IRKSCO* irkscoData, double *gout)
{
  TRACE_PUSH

  /* read input vars */
  externalInputUpdate(data);
  data->callback->input_function(data);
  /* eval needed equations*/
  data->callback->function_ZeroCrossingsEquations(data);

  data->callback->function_ZeroCrossings(data, gout);

  TRACE_POP
  return 0;
}

/*! \fn compareZeroCrossings
 *
 *  This function compares gout vs. gout_old and return 1,
 *  if they are not equal, otherwise it returns 0,
 *
 *  \param [ref] [data]
 *  \param [in] [gout]
 *  \param [in] [gout_old]
 *
 */
int compareZeroCrossings(DATA* data, double* gout, double* gout_old)
{
  TRACE_PUSH
  int i;

  for(i=0; i<data->modelData.nZeroCrossings; ++i)
    if(gout[i] != gout_old[i])
      return 1;

  TRACE_POP
  return 0;
}

/*!	\fn rk_imp_step
 *
 *  function does one implicit euler step with the stepSize given in radauStepSize
 *  function omc_newton is used for solving nonlinear system
 *  results will be saved in y_new
 *
 */
int rk_imp_step(DATA* data, SOLVER_INFO* solverInfo, double* y_new)
{
  int i, j, n=data->modelData.nStates;

  SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];
  modelica_real* stateDer = sData->realVars + data->modelData.nStates;
  NONLINEAR_SYSTEM_DATA* nonlinsys = data->simulationInfo.nonlinearSystemData;
  DATA_IRKSCO* userdata = (DATA_IRKSCO*)solverInfo->solverData;
  DATA_NEWTON* solverData = (DATA_NEWTON*) userdata->solverData;

  double a,b;

  sData->timeValue = userdata->radauTime + userdata->radauStepSize;
  solverInfo->currentTime = sData->timeValue;

  solverData->initialized = 1;
  solverData->numberOfIterations = 0;
  solverData->numberOfFunctionEvaluations = 0;
  solverData->n = n*userdata->ordersize;


  /* linear extrapolation for start value of newton iteration */
  for (i=0; i<n; i++)
  {
    if (userdata->radauStepSizeOld > 1e-16)
    {
      userdata->m[i] = (userdata->radauVars[i] - userdata->radauVarsOld[i]) / userdata->radauStepSizeOld;
      userdata->n[i] = userdata->radauVars[i] - userdata->radauTime * userdata->m[i];
    }
    else
    {
      userdata->m[i] = 0;
      userdata->n[i] = 0;
    }
  }

  /* initial guess calculated via linear extrapolation */
  for (i=0; i<userdata->ordersize; i++)
  {
    for (j=0; j<n; j++)
    {
      solverData->x[i*n+j] = userdata->m[j] * (userdata->radauTimeOld + userdata->c[i] * userdata->radauStepSize )+ userdata->n[j] - userdata->y0[j];
    }
  }



  userdata->data = (void*) data;

  solverData->newtonStrategy = NEWTON_DAMPED2;
  _omc_newton(wrapper_fvec_irksco, solverData, (void*)userdata);

  /* if newton solver did not converge, do iteration again but calculate jacobian in every step */
  if (solverData->info == -1)
  {
    for (i=0; i<userdata->ordersize; i++)
    {
      for (j=0; j<n; j++)
      {
        solverData->x[i*n+j] = userdata->m[j] * (userdata->radauTimeOld + userdata->c[i] * userdata->radauStepSize )+ userdata->n[j] - userdata->y0[j];
      }
    }
    solverData->numberOfIterations = 0;
    solverData->numberOfFunctionEvaluations = 0;
    solverData->calculate_jacobian = 1;

    warningStreamPrint(LOG_SOLVER, 0, "nonlinear solver did not converge at time %e, do iteration again with calculating jacobian in every step", solverInfo->currentTime);
    _omc_newton(wrapper_fvec_irksco, solverData, (void*)userdata);

    solverData->calculate_jacobian = -1;
  }

  for (j=0; j<n; j++)
  {
    y_new[j] = userdata->y0[j];
  }

  for (i=0; i<userdata->ordersize; i++)
  {
    if (userdata->d[i] != 0)
    {
      for (j=0; j<n; j++)
      {
        y_new[j] += userdata->d[i] * solverData->x[i*n+j];
      }
    }
  }


  return 0;
}


/*!	\fn wrapper_fvec_irksco
 *
 *  calculate function values or jacobian matrix
 *  fj = 1 ==> calculate function values
 *  fj = 0 ==> calculate jacobian matrix
 */
int wrapper_fvec_irksco(int* n, double* x, double* fvec, void* userdata, int fj)
{
  DATA* data = (DATA*)((DATA_IRKSCO*)userdata)->data;
  DATA_NEWTON* solverData = (DATA_NEWTON*)((DATA_IRKSCO*)userdata)->solverData;
  if (fj)
  {
    int i, j, k;
    DATA_IRKSCO* irkscoData = (DATA_IRKSCO*) userdata;
    DATA* data = irkscoData->data;
    int n0 = (*n)/irkscoData->ordersize;
    SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];
    modelica_real* stateDer = sData->realVars + data->modelData.nStates;

    ((DATA_IRKSCO*)userdata)->evalFunctionODE++;

    for (k=0; k < irkscoData->ordersize; k++)
    {
      for (j=0; j<n0; j++)
      {
        fvec[k*n0+j] = x[k*n0+j];
      }
    }

    for (i=0; i < irkscoData->ordersize; i++)
    {
      sData->timeValue = irkscoData->radauTimeOld + irkscoData->c[i] * irkscoData->radauStepSize;

      for (j=0; j < n0; j++)
      {
        sData->realVars[j] = irkscoData->y0[j] + x[n0*i+j];
      }


      externalInputUpdate(data);
      data->callback->input_function(data);
      data->callback->functionODE(data);

      for (k=0; k < irkscoData->ordersize; k++)
      {
        for (j=0; j<n0; j++)
        {
          fvec[k*n0+j] -= irkscoData->A[i*irkscoData->ordersize+k] * irkscoData->radauStepSize * stateDer[j];
        }
      }

    }
  }
  else
  {
    double delta_h = sqrt(solverData->epsfcn);
    double delta_hh;
    double xsave;

    int i,j,l;

    ((DATA_IRKSCO*)userdata)->evalJacobians++;

    for(i = 0; i < *n; i++)
    {
      delta_hh = fmax(delta_h * fmax(fabs(x[i]), fabs(fvec[i])), delta_h);
      delta_hh = ((fvec[i] >= 0) ? delta_hh : -delta_hh);
      delta_hh = x[i] + delta_hh - x[i];
      xsave = x[i];
      x[i] += delta_hh;
      delta_hh = 1. / delta_hh;

      wrapper_fvec_radau(n, x, solverData->rwork, userdata, 1);
      solverData->nfev++;

      for(j = 0; j < *n; j++)
      {
        l = i * *n + j;
        solverData->fjac[l] = (solverData->rwork[j] - fvec[j]) * delta_hh;
      }
      x[i] = xsave;
    }
  }
  return 0;
}

/*! \fn jacA_numColored
 *
 *  function calculates a jacobian matrix by
 *  numerical method finite differences
 *
 */
static int jacA_numColored(DATA* data, double *matrixA)
{
  TRACE_PUSH
  SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];
  modelica_real* stateDer = sData->realVars + data->modelData.nStates;
  const int index = data->callback->INDEX_JAC_A;
  double delta_h = 1e-8;
  double delta_hhh;
  int ires;
  const int n = data->modelData.nStates;
  double delta_hh[n];
  double ysave[n];
  double dersave[n];

  unsigned int i,j,l,k,ii;



  data->callback->initialAnalyticJacobianA((void*) data);

  infoStreamPrint(LOG_SOLVER, 0, "data->simulationInfo.analyticJacobians[index].sparsePattern.maxColors = %d",data->simulationInfo.analyticJacobians[index].sparsePattern.maxColors);
  infoStreamPrint(LOG_SOLVER, 0, "data->simulationInfo.analyticJacobians[index].sizeCols = %d",data->simulationInfo.analyticJacobians[index].sizeCols);


  for(i = 0; i < data->simulationInfo.analyticJacobians[index].sparsePattern.maxColors; i++)
  {
    for(ii=0; ii < data->simulationInfo.analyticJacobians[index].sizeCols; ii++)
    {
      if(data->simulationInfo.analyticJacobians[index].sparsePattern.colorCols[ii]-1 == i)
      {
        delta_hh[ii] = delta_h;
        delta_hh[ii] = (delta_hhh >= 0 ? delta_hh[ii] : -delta_hh[ii]);
        delta_hh[ii] = sData->realVars[ii] + delta_hh[ii] - sData->realVars[ii];

        ysave[ii] = sData->realVars[ii];
        dersave[ii] = stateDer[i];
        sData->realVars[ii] += delta_hh[ii];
        infoStreamPrint(LOG_SOLVER, 0, "sData->realVars[%d] = %e", ii, sData->realVars[ii]);

        delta_hh[ii] = 1. / delta_hh[ii];
      }
      else
      {
        infoStreamPrint(LOG_SOLVER, 0, "sData->realVars[%d] = %e", ii, sData->realVars[ii]);
      }
    }

    /* read input vars */
    externalInputUpdate(data);
    data->callback->input_function(data);
    data->callback->functionODE(data);

    for(ii = 0; ii < data->simulationInfo.analyticJacobians[index].sizeCols; ii++)
    {
      if(data->simulationInfo.analyticJacobians[index].sparsePattern.colorCols[ii]-1 == i)
      {
        if(ii==0)
          j = 0;
        else
          j = data->simulationInfo.analyticJacobians[index].sparsePattern.leadindex[ii-1];
        while(j < data->simulationInfo.analyticJacobians[index].sparsePattern.leadindex[ii])
        {
          l  =  data->simulationInfo.analyticJacobians[index].sparsePattern.index[j];
          k  = l + ii*data->simulationInfo.analyticJacobians[index].sizeRows;
          matrixA[k] = (stateDer[l] - dersave[l]) * delta_hh[ii];
          /*infoStreamPrint(ACTIVE_STREAM(LOG_JAC),"write %d. in jac[%d]-[%d,%d]=%e",ii,k,j,l,matrixA[k]);*/
          j++;
        };
        sData->realVars[ii] = ysave[ii];
        stateDer[ii] = dersave[ii];
      }
    }
  }

  /*
   * Debug output
  if(ACTIVE_STREAM(LOG_JAC))
  {
    infoStreamPrint(LOG_SOLVER, "Print jac:");
    for(i=0;  i < data->simulationInfo.analyticJacobians[index].sizeRows;i++)
    {
      for(j=0;  j < data->simulationInfo.analyticJacobians[index].sizeCols;j++)
        printf("%.20e ",matrixA[i+j*data->simulationInfo.analyticJacobians[index].sizeCols]);
      printf("\n");
    }
  }
   */

  TRACE_POP
  return 0;
}

/*! \fn refreshModel
 *
 *  function updates values in sData->realVars
 *
 *  used for solver 'irksco'
 */
static
int refreshModel(DATA* data, double* x, double time)
{
  SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];

  memcpy(sData->realVars, x, sizeof(double)*data->modelData.nStates);
  sData->timeValue = time;
  /* read input vars */
  externalInputUpdate(data);
  data->callback->input_function(data);
  data->callback->functionODE(data);

  return 0;
}

/*! \fn irksco_richardson
 *
 *  function does one integration step and calculates
 *  next step size by richardson extrapolation
 *
 *  used for solver 'irksco'
 */
int irksco_richardson(DATA* data, SOLVER_INFO* solverInfo)
{
  SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];
  SIMULATION_DATA *sDataOld = (SIMULATION_DATA*)data->localData[1];
  modelica_real* stateDer = sData->realVars + data->modelData.nStates;
  DATA_IRKSCO* userdata = (DATA_IRKSCO*)solverInfo->solverData;
  DATA_NEWTON* solverData = (DATA_NEWTON*)userdata->solverData;

  double sc, err, a, b, c0, c1, c2;
  double Atol = data->simulationInfo.tolerance, Rtol = data->simulationInfo.tolerance;
  int i;
  double fac = 0.9;
  double facmax = 5.0;
  double facmin = 0.3;
  double targetTime;
  int foundEvent = 0;


  /* Calculate steps until targetTime is reached */
  if (solverInfo->integratorSteps)
  {
    targetTime = data->simulationInfo.stopTime;
  }
  else
  {
    targetTime = sDataOld->timeValue + solverInfo->currentStepSize;
  }

  if (userdata->firstStep  || solverInfo->didEventStep == 1)
  {
    radau_first_step(data, solverInfo);
    userdata->radauStepSizeOld = 0;
  }

  checkForZeroCrossingsRADAU(data, userdata, userdata->zeroCrossingValuesOld);

  while (userdata->radauTime < targetTime)
  {
    infoStreamPrint(LOG_SOLVER,0, "new step: time=%e", userdata->radauTime);

    rt_ext_tp_tick(&(solverData->timeClock));

    do
    {
      err = 0.0;

      /*** one step with doubled step size ***/

      userdata->radauStepSize *= 2.0;

      memcpy(userdata->y0, userdata->radauVars, data->modelData.nStates*sizeof(double));

      /* calculate jacobian once for the first step*/
      solverData->calculate_jacobian = 0;

      euler_imp_step(data, solverInfo, userdata->y1);

      fac = 0.9 * (solverData->maxfev + 1) / (solverData->maxfev + solverData->numberOfIterations);

      /*** two steps with original step size ***/
      userdata->radauStepSize /= 2.0;

      /* do not calculate jacobian again */
      solverData->calculate_jacobian = -1;

      euler_imp_step(data, solverInfo, userdata->y05);

      memcpy(userdata->y0, userdata->y05, data->modelData.nStates*sizeof(double));

      userdata->radauTime += userdata->radauStepSize;

      euler_imp_step(data, solverInfo, userdata->y2);

      userdata->radauTime -= userdata->radauStepSize;

      /* calculate error */
      for (i=0; i<data->modelData.nStates; i++)
      {
        sc = Atol + fmax(fabs(userdata->y2[i]),fabs(userdata->y1[i]))*Rtol;
        err += (((userdata->y2[i]-userdata->y1[i])*(userdata->y2[i]-userdata->y1[i]))/(sc*sc));
      }

      err /= data->modelData.nStates;
      err = sqrt(err);

      userdata->stepsDone += 1;
      infoStreamPrint(LOG_SOLVER, 0, "err = %e", err);
      infoStreamPrint(LOG_SOLVER, 0, "min(facmax, max(facmin, fac*sqrt(1/err))) = %e",  fmin(facmax, fmax(facmin, fac*sqrt(1.0/err))));

      userdata->radauStepSizeOld =  2.0*userdata->radauStepSize;
      userdata->radauStepSize *=  fmin(facmax, fmax(facmin, fac*sqrt(1.0/err)));
      if (isnan(userdata->radauStepSize))
        userdata->radauStepSize = 1e-6;

    } while  (err > 1.0 );

    infoStreamPrint(LOG_SOLVER, 0, "###  %f  time for step", rt_ext_tp_tock(&(solverData->timeClock)));
    infoStreamPrint(LOG_SOLVER, 0, "### number of iterations: %d", solverData->numberOfIterations);

    /* update values */
    userdata->radauTimeOld = userdata->radauTime;
    userdata->radauTime = userdata->radauTimeOld + userdata->radauStepSizeOld;

    memcpy(userdata->radauVarsOld, userdata->radauVars, data->modelData.nStates*sizeof(double));
    memcpy(userdata->radauVars, userdata->y2, data->modelData.nStates*sizeof(double));


    /* update time and states */
    sData->timeValue = userdata->radauTime;
    memcpy(sData->realVars, userdata->radauVars, data->modelData.nStates*sizeof(double));

    /*check for events*/
    checkForZeroCrossingsIrksco(data, userdata, userdata->zeroCrossingValues);

    if (compareZeroCrossings(data, userdata->zeroCrossingValues, userdata->zeroCrossingValuesOld)){
      foundEvent = 1;
      break;
    }
    /* emit step, if integratorSteps is selected */
    if (solverInfo->integratorSteps)
    {
      /*
       * to emit consistent value we need to update the whole
       * continuous system with algebraic variables.
       */
      updateContinuousSystem(data);
      sim_result.emit(&sim_result, data);
    }
  }

  if (foundEvent == 0){


    /* interpolate values for outer loop */
    /* linear interpolation */
    if (!solverInfo->integratorSteps)
    {
      double a,b;
      solverInfo->currentTime = sDataOld->timeValue + solverInfo->currentStepSize;
      sData->timeValue = solverInfo->currentTime;
      for (i=0; i<data->modelData.nStates; i++)
      {
        a = (userdata->radauVars[i] - userdata->radauVarsOld[i]) / userdata->radauStepSizeOld;
        b = userdata->radauVars[i] - userdata->radauTime * a;
        sData->realVars[i] = a * sData->timeValue + b;
      }
    }
    else
    {
      solverInfo->currentTime = userdata->radauTime;
    }
  }
  else{
    solverInfo->currentTime = userdata->radauTime;
  }


  return 0;
}

/*! \fn irksco_midpoint_rule
 *
 *  function does one integration step and calculates
 *  next step size by the implicit midpoint rule
 *
 *  used for solver 'irksco'
 */
int irksco_midpoint_rule(DATA* data, SOLVER_INFO* solverInfo)
{
  SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];
  SIMULATION_DATA *sDataOld = (SIMULATION_DATA*)data->localData[1];
  modelica_real* stateDer = sData->realVars + data->modelData.nStates;
  DATA_IRKSCO* userdata = (DATA_IRKSCO*)solverInfo->solverData;
  DATA_NEWTON* solverData = (DATA_NEWTON*)userdata->solverData;

  double sc, err, a, b, diff;
  double Atol = data->simulationInfo.tolerance, Rtol = data->simulationInfo.tolerance;
  int i;
  double fac = 0.9;
  double facmax = 3.5;
  double facmin = 0.3;
  double saveTime = sDataOld->timeValue;
  double targetTime;



  /* Calculate steps until targetTime is reached */
  if (solverInfo->integratorSteps)
  {
    targetTime = data->simulationInfo.stopTime;
  }
  else
  {
    targetTime = sDataOld->timeValue + solverInfo->currentStepSize;
  }

  if (userdata->firstStep  || solverInfo->didEventStep == 1)
  {
    radau_first_step(data, solverInfo);
    userdata->radauStepSizeOld = 0;
  }

  memcpy(userdata->y0, sDataOld->realVars, data->modelData.nStates*sizeof(double));

  while (userdata->radauTime < targetTime)
  {
    infoStreamPrint(LOG_SOLVER,0, "new step: time=%e", userdata->radauTime);

    do
    {
      /*** do one step with original step size ***/

      /* set y0 */
      memcpy(userdata->y0, userdata->radauVars, data->modelData.nStates*sizeof(double));

      /* calculate jacobian once for the first iteration */
      if (userdata->stepsDone == 0)
        solverData->calculate_jacobian = 0;

      /* solve nonlinear system */
      euler_imp_step(data, solverInfo, userdata->y05);

      /* extrapolate values in y1 */
      for (i=0; i<data->modelData.nStates; i++)
      {
        userdata->y1[i] = 2.0*userdata->y05[i] - userdata->radauVars[i];
      }

      /*** do another step with original step size ***/

      /* update y0 */
      memcpy(userdata->y0, userdata->y05, data->modelData.nStates*sizeof(double));

      /* update time */
      userdata->radauTime += userdata->radauStepSize;

      /* do not calculate jacobian again */
      solverData->calculate_jacobian = -1;

      /* solve nonlinear system */
      euler_imp_step(data, solverInfo, userdata->y2);

      /* reset time */
      userdata->radauTime -= userdata->radauStepSize;


      /*** calculate error ***/
      for (i=0, err=0.0; i<data->modelData.nStates; i++)
      {
        sc = Atol + fmax(fabs(userdata->y2[i]),fabs(userdata->y1[i]))*Rtol;
        diff = userdata->y2[i]-userdata->y1[i];
        err += (diff*diff)/(sc*sc);
      }

      err /= data->modelData.nStates;
      err = sqrt(err);

      userdata->stepsDone += 1;
      infoStreamPrint(LOG_SOLVER, 0, "err = %e", err);
      infoStreamPrint(LOG_SOLVER, 0, "min(facmax, max(facmin, fac*sqrt(1/err))) = %e",  fmin(facmax, fmax(facmin, fac*sqrt(1.0/err))));

      /* update step size */
      userdata->radauStepSizeOld = 2.0*userdata->radauStepSize;
      userdata->radauStepSize *=  fmin(facmax, fmax(facmin, fac*sqrt(1.0/err)));

      if (isnan(userdata->radauStepSize))
      {
        userdata->radauStepSize = 1e-6;
      }

    } while  (err > 1.0 );

    userdata->radauTimeOld = userdata->radauTime;

    userdata->radauTime += userdata->radauStepSizeOld;

    memcpy(userdata->radauVarsOld, userdata->radauVars, data->modelData.nStates*sizeof(double));
    memcpy(userdata->radauVars, userdata->y2, data->modelData.nStates*sizeof(double));

    /* emit step, if integratorSteps is selected */
    if (solverInfo->integratorSteps)
    {
      sData->timeValue = userdata->radauTime;
      memcpy(sData->realVars, userdata->radauVars, data->modelData.nStates*sizeof(double));
      /*
       * to emit consistent value we need to update the whole
       * continuous system with algebraic variables.
       */
      updateContinuousSystem(data);
      sim_result.emit(&sim_result, data);
    }
  }

  if (!solverInfo->integratorSteps)
  {
    solverInfo->currentTime = sDataOld->timeValue + solverInfo->currentStepSize;
    sData->timeValue = solverInfo->currentTime;
    /* linear interpolation */
    for (i=0; i<data->modelData.nStates; i++)
    {

      a = (userdata->radauVars[i] - userdata->radauVarsOld[i]) / userdata->radauStepSizeOld;
      b = userdata->radauVars[i] - userdata->radauTime * a;
      sData->realVars[i] = a * sData->timeValue + b;
    }
  }else{
    solverInfo->currentTime = userdata->radauTime;
  }

  return 0;
}

/*! \fn irksco_first_step
 *
 *  function initializes values and calculates
 *  initial step size at the beginning or after an event
 *
 */
void irksco_first_step(DATA* data, SOLVER_INFO* solverInfo)
{
  SIMULATION_DATA *sData = (SIMULATION_DATA*)data->localData[0];
  SIMULATION_DATA *sDataOld = (SIMULATION_DATA*)data->localData[1];
  DATA_IRKSCO* userdata = (DATA_IRKSCO*)solverInfo->solverData;
  const int n = data->modelData.nStates;
  double jacobian[n*n];
  modelica_real* stateDer = sData->realVars + data->modelData.nStates;
  double sc, d, d0 = 0.0, d1 = 0.0, d2 = 0.0, h0, h1, delta_ti, infNorm, sum = 0;
  double Atol = 1e-6, Rtol = 1e-3;

  int i,j;

  /* initialize radau values */
  for (i=0; i<data->modelData.nStates; i++)
  {
    userdata->radauVars[i] = sData->realVars[i];
    userdata->radauVarsOld[i] = sDataOld->realVars[i];
  }

  userdata->radauTime = sDataOld->timeValue;
  userdata->radauTimeOld = sDataOld->timeValue;

  userdata->firstStep = 0;
  solverInfo->didEventStep = 0;


  /* calculate starting step size 1st Version */

  refreshModel(data, sDataOld->realVars, sDataOld->timeValue);


  for (i=0; i<data->modelData.nStates; i++)
  {
    sc = Atol + abs(sDataOld->realVars[i])*Rtol;
    d0 += ((sDataOld->realVars[i] * sDataOld->realVars[i])/(sc*sc));
    d1 += ((stateDer[i] * stateDer[i]) / (sc*sc));
  }
  d0 /= data->modelData.nStates;
  d1 /= data->modelData.nStates;

  d0 = sqrt(d0);
  d1 = sqrt(d1);


  for (i=0; i<data->modelData.nStates; i++)
  {
    userdata->der_x0[i] = stateDer[i];
  }

  if (d0 < 1e-5 || d1 < 1e-5)
  {
    h0 = 1e-6;
  }
  else
  {
    h0 = 0.01 * d0/d1;
  }


  for (i=0; i<data->modelData.nStates; i++)
  {
    sData->realVars[i] = userdata->radauVars[i] + stateDer[i] * h0;
  }
  sData->timeValue += h0;

  externalInputUpdate(data);
  data->callback->input_function(data);
  data->callback->functionODE(data);


  for (i=0; i<data->modelData.nStates; i++)
  {
    sc = Atol + abs(userdata->radauVars[i])*Rtol;
    d2 += ((stateDer[i]-userdata->der_x0[i])*(stateDer[i]-userdata->der_x0[i])/(sc*sc));
  }

  d2 /= h0;
  d2 = sqrt(d2);


  d = fmax(d1,d2);

  if (d > 1e-15)
  {
    h1 = sqrt(0.01/d);
  }
  else
  {
    h1 = fmax(1e-6, h0*1e-3);
  }

  userdata->radauStepSize = 0.5*fmin(100*h0,h1);

  /* end calculation new step size */

  /* calculate starting step size - 2nd Version

	refreshModel(data, sDataOld->realVars, sDataOld->timeValue);

	userdata->radauStepSize = fabs(Rtol * data->modelData.realVarsData[0].attribute.nominal / stateDer[0]);

	for (i=1; i< data->modelData.nStates; i++)
	{
		delta_ti = fabs(Rtol * data->modelData.realVarsData[i].attribute.nominal / stateDer[i]);

		if (userdata->radauStepSize > delta_ti && delta_ti == delta_ti)
		{
			userdata->radauStepSize = delta_ti;
			infoStreamPrint(LOG_SOLVER, 0, "delta_ti = %e", delta_ti);
		}
	}

	userdata->radauStepSize *= 0.5;

	/* end calculation */

  /* calculate starting step size - 3rd Version
	jacA_numColored(data, jacobian);

	for (i=0; i < n; i++)
	{
		for (j=0; j < n; j++)
		{
			infoStreamPrint(LOG_SOLVER, 0, "A[%d] = %e", i*n+j, jacobian[i*n+j]);
		}
	}

	for (j=0; j < n; j++)
	{
		sum += jacobian[j] * stateDer[j];
	}
	infNorm = sum;


	for (i=1; i < n; i++)
	{
		sum = 0;
		for (j=0; j < n; j++)
		{
			sum += jacobian[i*n+j] * stateDer[j];
		}

		if (abs(sum) > infNorm)
		{
			infNorm = abs(sum);
		}
	}

	infoStreamPrint(LOG_SOLVER, 0, "infNorm = %e", infNorm);

	if (infNorm > 0 )
	{
		userdata->radauStepSize = sqrt(5.0/infNorm);
	}
	else
	{
		userdata->radauStepSize = 0.01;
	}

	/* end calculation */

  infoStreamPrint(LOG_SOLVER, 0, "initial step size = %e", userdata->radauStepSize);
}
