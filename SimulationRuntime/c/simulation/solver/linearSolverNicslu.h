#include "omc_config.h"

#ifndef _LINEARSOLVERNICSLU_H_
#define _LINEARSOLVERNICSLU_H_

#include "simulation_data.h"
#include "nicslu/nicslu.h"

typedef struct DATA_NICSLU
{
	SNicsLU *nicslu;
	unsigned int n;
	unsigned int nnz;
	double *ax;
	unsigned int *ai;
	unsigned int *ap;
	double *x;

	double* work;

	rtclock_t timeClock;  /* time clock -> Modelica eigen*/
	int numberSolving;

} DATA_NICSLU;

int allocateNicsluData(unsigned int n, unsigned int nnz, void **data);
int freeNicsluData(void **data);
int solveNicslu(DATA *data, threadData_t *threadData, int sysNumber);

#endif

