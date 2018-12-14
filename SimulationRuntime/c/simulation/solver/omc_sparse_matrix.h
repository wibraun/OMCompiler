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

/*! \file omc_sparse_matrix.h
 */

#ifndef _OMC_SPARSE_MATRIX_H_
#define _OMC_SPARSE_MATRIX_H_

typedef enum {
    ROW_WISE,
    COLUMN_WISE
} omc_matrix_orientation;

typedef struct omc_sparse_matrix{
  int* index;
  int* ptr;
  double* data;

  unsigned int size_rows;
  unsigned int size_cols;
  unsigned int nnz;

  omc_matrix_orientation orientation = COLUMN_WISE;
};


omc_sparse_matrix* allocate_sparse_matrix(int size_rows, int size_cols, int nnz, omc_matrix_orientation orientation);
void free_sparse_matrix(omc_sparse_matrix* A);

void set_zero_sparse_matrix(omc_sparse_matrix* A);
omc_sparse_matrix* copy_sparse_matrix(omc_sparse_matrix* A);

void set_sparse_matrix_element(omc_sparse_matrix* A, int row, int col, int nth, double value);
double get_sparse_matrix_element(omc_sparse_matrix* A, int row, int col);


void scale_sparse_matrix(omc_sparse_matrix* A, double scalar);

void print_sparse_matrix(omc_sparse_matrix* A);


#endif
