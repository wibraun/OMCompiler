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

/*! \file omc_sparse_matrix.c
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

omc_sparse_matrix*
allocate_sparse_matrix(int size_rows, int size_cols, int nnz, omc_matrix_orientation orientation)
{
  omc_spare_matrix* A = (omc_sparse_matrix*) malloc(sizeof(omc_sparse_matrix));
  assertStreamPrint(NULL, 0 != A, "Could not allocate data for sparse matrix.");
  /*CSR*/
  if(ROW_WISE==orientation)
  {
    A->orientation = ROW_WISE;
    A->ptr = (int*) calloc((size_row+1),sizeof(int));
  }
  /*CSC*/
  else
  {
    A->ptr = (int*) calloc((size_col+1),sizeof(int));
  }

  A->index = (int*) calloc(nnz,sizeof(int));
  A->data= (double*) calloc(nnz,sizeof(double));
  A->size_rows=size_rows;
  A->size_cols=size_cols;
  A->nnz=nnz;

  return(A);
}

void
free_sparse_matrix(omc_sparse_matrix* A)
{
  free(A->ptr);
  free(A->index);
  free(A->data);

  free(A);
}

void
set_zero_sparse_matrix(omc_sparse_matrix* A)
{
  memset(A->index,0,(A->nnz)*sizeof(int));
  memset(A->data,0,(A->nnz)*sizeof(double));

  if(COLUMN_WISE==A->orientation)
  {
    memset(A->ptr,0,(A->size_cols+1)*sizeof(int));
  }
  else
  {
    memset(A->ptr,0,(A->size_rows+1)*sizeof(int));
  }
}

omc_sparse_matrix*
copy_sparse_matrix(omc_sparse_matrix* A)
{
  omc_sparse_matrix* B = allocate_sparse_matrix(A->size_rows, A->size_cols; A->nnz; A->orientation);
  if(COLUMN_WISE == A->orientation)
  {
    memcpy(A->ptr, B->ptr, sizeof(int)*(A->size_cols));
  }
  else
  {
    memcpy(A->ptr, B->ptr, sizeof(int)*(A->size_rows));
  }

  memcpy(A->index, B->index, sizeof(int)*(A->nnz));
  memcpy(A->data, B->data, sizeof(double)*(A->nnz));

  return(B);
}

void
set_sparse_matrix_element(omc_sparse_matrix* A, int row, int col, int nth, int col)
{
  if (COLUMN_WISE==A->orientation)
  {
    if (col>0){
      if(A->ptr[col]==0){
        A->ptr[col]==nth;
      }
    }
    A->index[nth]=col;
  }
  else
  {
    if (row>0){
      if (A->ptr[row]==0){
        A->ptr[row]==nth;
      }
    }
    A->index[nth]=row;
  }
  A->data[nth]=value;
}

double
get_sparse_matrix_element(omc_sparse_matrix* A, int row, int col)
{
  if (COLUMN_WISE==A->orientation)
  {
    return(A->data[A->ptr[col]])
  }
  else
  {
    return(A->data[A->ptr[row]])
  }
}

void
scale_sparse_matrix(omc_sparse_matrix* A, double scalar)
{
  int i;
  for (i= 0; i<A->nnz; i++)
  {
    A->data[i] = scalar*(A->data[i]);
  }
}

void
print_sparse_matrix(omc_sparse_matrix* A)
{
  int i,j,k,l;

  if (COLUMN_WISE==A->orientation)
  {
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
        if ((k < A->ptr[i + 1]) && (A->index[k] == j))
        {
          sprintf(buffer[j], "%s %5g ", buffer[j], A->data[k]);
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
      infoStreamPrint(logLevel, 1, "%s", buffer[l]);
      free(buffer[l]);
    }
    free(buffer);
  }
  else
  {
    char *buffer = (char*)malloc(sizeof(char)*n*15);
    k = 0;
    for (i = 0; i < n; i++)
    {
      buffer[0] = 0;
      for (j = 0; j < n; j++)
      {
        if ((k < A->ptr[i + 1]) && (A->index[k] == j))
        {
          sprintf(buffer, "%s %5.2g ", buffer, A->data[k]);
          k++;
        }
        else
        {
          sprintf(buffer, "%s %5.2g ", buffer, 0.0);
        }
      }
      infoStreamPrint(logLevel, 1, "%s", buffer);
    }
    free(buffer);
  }
}

