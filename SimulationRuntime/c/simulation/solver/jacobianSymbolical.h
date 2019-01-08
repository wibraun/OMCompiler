/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-2016, Open Source Modelica Consortium (OSMC),
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

 /*! \file jacobianSymbolical.h
 */

#ifndef OMC_JACOBIAN_SYMBOLICAL_H
#define OMC_JACOBIAN_SYMBOLICAL_H

#include "simulation_data.h"


/* Allocate thread local Jacobians in case of OpenMP-parallel Jacobian computation (symbolical only) in IDA and Dassl.*/
void allocateThreadLocalJacobians(DATA* data, ANALYTIC_JACOBIAN** jacColumns);

/** Generic parallel computation of the colored Jacobian for IDA and Dassl.
 *
 * Since, the procedure of Jacobian computation for IDA and Dassl differ only in the matrix storage format, a
 * generic method can be used. By doing so, the maintainability is increased while redundant code is reduced.
 *
 * The computation of the different columns are independent from each other and have been parallelised using OpenMP.
 *
 * @param f Pointer to function that sets the values within Jacobian (of different format for different solvers).
 */
void genericParallelColoredSymbolicJacobianEvaluation(int rows, int columns, SPARSE_PATTERN* spp,
                                                      void* matrixA, ANALYTIC_JACOBIAN* jacColumns,
                                                      DATA* data,
                                                      threadData_t* threadData,
                                                      void (*f)(int, int, int, double, void*, int));

#endif
