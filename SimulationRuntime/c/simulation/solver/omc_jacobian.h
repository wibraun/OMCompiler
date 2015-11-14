/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Open Source Modelica Consortium (OSMC),
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

#ifndef OMCJACOBIAN_H_
#define OMCJACOBIAN_H_

#include "simulation_data.h"

typedef struct SYMBOLIC_JAC_PARDATA
{
  unsigned int sizeSeedVars;
  unsigned int sizeTmpVars;
  unsigned int sizeResultVars;
  modelica_real* seedVars;
  modelica_real* tmpVars;
  modelica_real* resultVars;
  unsigned int numProcess;


  void *tid;
  void *parFuncArgs;
  void *anaJacs;

}SYMBOLIC_JAC_PARDATA;

SYMBOLIC_JAC_PARDATA* allocateSymbolicJacParData(unsigned int numProcess, unsigned int sizeSeedVars, unsigned int sizeTmpVars, unsigned int sizeResultVars, SPARSE_PATTERN* sparsePattern);
void freeSymbolicJacParData(SYMBOLIC_JAC_PARDATA* symJacParData);
int getSymbolicalJacobian(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN* analyticJacobian),  double* jac);
int getSymbolicalJacobianPar(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN* analyticJacobian, int (*analyticalJacobianColumn)(void*, threadData_t*, ANALYTIC_JACOBIAN* analyticJacobian),  double* jac);

#endif
