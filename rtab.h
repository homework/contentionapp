/*
 * The Homework Database
 *
 * Results Table
 *
 * Authors:
 *    Oliver Sharma and Joe Sventek
 *     {oliver, joe}@dcs.gla.ac.uk
 *
 * (c) 2009. All rights reserved.
 */
#ifndef HWDB_RTAB_H
#define HWDB_RTAB_H

#include "config.h"
#include "srpc.h"
#include "sqlstmts.h"

/* Rtab Status flags */
#define RTAB_MSG_SUCCESS 0
#define RTAB_MSG_ERROR 1
#define RTAB_MSG_CREATE_FAILED 2
#define RTAB_MSG_INSERT_FAILED 3
#define RTAB_MSG_SAVE_SELECT_FAILED 4
#define RTAB_MSG_SUBSCRIBE_FAILED 5
#define RTAB_MSG_UNSUBSCRIBE_FAILED 6
#define RTAB_MSG_PARSING_FAILED 7
#define RTAB_MSG_SELECT_FAILED 8
#define RTAB_MSG_EXEC_SAVED_SELECT_FAILED 9
#define RTAB_MSG_CLOSE_FLAG 10
#define RTAB_MSG_DELETE_QUERY_FAILED 11
#define RTAB_MSG_NO_TABLES_DEFINED 12

typedef struct rrow {
	char **cols;	/* All data stored as strings */
} Rrow;

typedef struct rtab {
	int nrows;
	int ncols;
	char **colnames;	/* Array of column names */
	int  **coltypes;	/* Array of column data types */
	Rrow **rows; 		/* Array of rows (data) */
	
	/* Embedded messages (e.g. error messages) */
	char mtype;
	char *msg;
} Rtab;

Rtab *rtab_new();
Rtab *rtab_new_msg(char mtype);
void  rtab_free(Rtab *results);

char **rtab_getrow(Rtab *results, int row);
void   rtab_print(Rtab *results);

int rtab_pack(Rtab *results, char *packed, int size, int *len);
Rtab *rtab_unpack(char *packed, int len);
int rtab_status(char *packed, char *stsmsg);

int   rtab_send(Rtab *results, RpcConnection outgoing);

/* Manipulators */
void rtab_orderby(Rtab *results, char *colname);
void rtab_countstar(Rtab *results);
char *rtab_process_min(Rtab *results, int col);
char *rtab_process_max(Rtab *results, int col);
char *rtab_process_avg(Rtab *results, int col);
char *rtab_process_sum(Rtab *results, int col);
void rtab_to_onerow_if_no_others(Rtab *results);
void rtab_processMinMaxAvgSum(Rtab *results, int** colattrib);
void rtab_replace_col_val(Rtab *results, int c, char *val);
void rtab_update_colname(Rtab *results, int c, char *prefix);

/* for debugging */
Rtab *rtab_fake_results();

#endif
