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

/*! \file omc_matrix.c
 */
#include "omc_config.h"

#include <math.h>
#include <stdlib.h>
#include <string.h>

#include "simulation_data.h"
#include "simulation/simulation_info_json.h"
#include "util/omc_error.h"
#include "util/varinfo.h"
#include "model_help.h"

#include "omc_spares_matrix.h"
#include "omc_math.h"
#include "omc_matrix.h"

/**
 * Allocates memory for specific matrix and identifies the type of matrix.
 *
 * \param [in]     size_rows            Size of Rows in Matrix.
 * \param [in]     size_cols            Size of Columns in Matrix.
 * \param [in]     nnz                  Number of nonzero elements in Matrix.
 * \param [in]     orientation          Matrix initialisation, Row wise or Column wise
 * \param [in]     type                 Dense or Sparse Matrix
 * \param [out]    omc_matrix           Structur
 */
omc_matrix*
allocate_sparse_matrix(int size_rows, int size_cols, int nnz, omc_matrix_orientation orientation, omc_matrix_type type;)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

void
free_sparse_matrix(omc_matrix* A)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

void
set_zero_sparse_matrix(omc_matrix* A)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

omc_sparse_matrix*
copy_sparse_matrix(omc_matrix* A)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

void
set_sparse_matrix_element(omc_matrix* A, int row, int col, int nth, double value)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

double
get_sparse_matrix_element(omc_matrix* A, int row, int col)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

void scale_sparse_matrix(omc_matrix* A, double scalar)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

void print_sparse_matrix(omc_matrix* A)
{
  switch (type)
    {
    case DENSE_MATRIX:

      break;
    case SPARSE_MATRIX:

      break;
    default:
      break;
    }
}

