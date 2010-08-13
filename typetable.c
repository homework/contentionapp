/* typetable.c
 * 
 * Typetable of supported types
 * 
 * Created by Joe Sventek on 2009-05-03.
 * Copyright (c) 2009. All rights reserved.
 */

#include "typetable.h"
#include <string.h>

int primtype_val[NUM_PRIMTYPES] = {0,1,2,3,4,5,6,7,8};

const int primtype_size[NUM_PRIMTYPES] = {	sizeof(char),
	sizeof(int), sizeof(double), sizeof(char), VARIABLESIZE,
	VARIABLESIZE, sizeof(char), sizeof(short), sizeof(long long)};

const char *primtype_name[NUM_PRIMTYPES] = {"boolean", "integer",
	"real", "character", "varchar", "blob", "tinyint", "smallint",
	"timestamp"};

int typetable_index(char *name) {
	int i;

	for (i = 0; i < NUM_PRIMTYPES; i++)
		if (strcmp(name, primtype_name[i]) == 0)
			return i;
	return -1;
}
