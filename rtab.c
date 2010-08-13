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
#include "rtab.h"
#include "util.h"
#include "typetable.h"
#include "sqlstmts.h"
#include "mem.h"
#include "logdefs.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define RTAB_EMPTY "[Empty]"
#define RTAB_EMPTY_LEN 8





static const char *separator = "<|>"; /* separator between packed fields */
static const char *error_msgs[] = {"Success", "Error", "Create_failed",
                                   "Insert_failed", "Save_select_failed",
				   "Subscribe_failed", "Unsubscribe_failed",
				   "Parsing failed", "Select_failed",
				   "Exec_saved_select_failed", "Close_flag",
				   "Delete_query_failed", "No_tables_defined"};
Rtab *rtab_new() {
	Rtab *results;
	
	results = mem_alloc(sizeof(Rtab));
	results->nrows = 0;
	results->ncols = 0;
	results->colnames = NULL;
	results->coltypes = NULL;
	results->rows = NULL;
	results->mtype = RTAB_MSG_SUCCESS;
	results->msg = (char *)error_msgs[0];
	
	return results;
}

Rtab *rtab_new_msg(char mtype) {
	Rtab *results = rtab_new();
	results->mtype = mtype;
	results->msg = (char *)error_msgs[(int)mtype];
	return results;
}

static void rtab_purge(Rtab *results) {
        int i, j;

        for (i = 0; i < results->ncols; i++)
               	mem_free(results->colnames[i]);
        for (i = 0; i < results->nrows; i++) {
                for (j = 0; j < results->ncols; j++)
                        mem_free(results->rows[i]->cols[j]);
		mem_free(results->rows[i]->cols);
                mem_free(results->rows[i]);
        }
        mem_free(results->colnames);
        mem_free(results->coltypes);
        mem_free(results->rows);
	results->nrows = 0;
	results->ncols = 0;
	results->colnames = NULL;
	results->coltypes = NULL;
	results->rows = NULL;
}

void rtab_free(Rtab *results) {

	debugvf("Rtab: free.\n");
	
	if (!results)
		return;
	
	rtab_purge(results);
	mem_free(results);
}

char **rtab_getrow(Rtab *results, int row) {
	return results->rows[row]->cols;
}

void  rtab_print(Rtab *results) {
	int c, r;
	char **row;
	
	if (!results) {
		printf("[Results is Empty]\n");
		return;
	}
	
	printf("==============\nResults:\n");
	
	printf("Status message: %s\n", results->msg);
	
	printf("Nrows: %d, Ncols: %d\n", results->nrows, results->ncols);
	if (results->nrows <= 0)
		return;
	printf("Col headers: ");
	for (c=0; c<results->ncols; c++) {
	    printf("%s%s (%s)", (c == 0) ? " " : ", ", results->colnames[c], 
	           primtype_name[*results->coltypes[c]]);
	}
	printf("\n-----------------\n");
	
	for (r=0; r<results->nrows; r++) {
		row = rtab_getrow(results, r);
		for (c=0; c<results->ncols; c++) {
			printf("%s ", row[c]);
		}
		printf("\n-----------------\n");
	}
	
	printf("==============\n");
}


int rtab_pack(Rtab *results, char *packed, int size, int *len) {
	int sofar, buflen;
	int c, r;
	char **row;
	int ncols = results->ncols;
	int status = 1;
	char buf[4096];
	
	debugf("Packing rtab\n");
	
	sofar = 0;
	
	sofar += sprintf(packed+sofar, "%d%s%s%s", results->mtype, separator, results->msg, separator);
	if (results->nrows <= 0)
		ncols = 0;
	sofar += sprintf(packed+sofar, "%d%s%d%s\n", ncols, separator, results->nrows, separator);
    if (results->nrows <= 0) {
	*len = sofar;
	return status;
    }
	for (c=0; c < results->ncols; c++) {
		sofar += sprintf(packed+sofar, "%s:%s%s", primtype_name[*results->coltypes[c]], results->colnames[c], separator);
	}
	sofar += sprintf(packed+sofar, "\n");
	for (r=0; r<results->nrows; r++) {
		row = rtab_getrow(results, r);
		buflen = 0;
		for (c=0; c<results->ncols; c++) {
		    buflen += sprintf(buf+buflen, "%s%s", row[c], separator);
		}
		buflen += sprintf(buf+buflen, "\n");
		if ((sofar + buflen) > size) {
			status = 0;		/* buffer overrun */
			break;
		}
		sofar += sprintf(packed+sofar, "%s", buf);
	}
	
	*len = sofar;
	return status;
}

/*
 * static routines used by rtab_unpack to obtain integers and strings from
 * the packed buffers received over the network
 */
static char *fetch_int(char *p, int *value) {
    char *q, c;
    
    if ((q = strstr(p, separator)) != NULL) {
	c = *q;
	*q = '\0';
	*value = atoi(p);
	*q = c;
	q += strlen(separator);
    } else
	*value = 0;
    return q;
}

static char *fetch_str(char *p, char *str, int *len) {
    char *q, c;

    if ((q = strstr(p, separator)) != NULL) {
	c = *q;
	*q = '\0';
	strcpy(str, p);
	*q = c;
	q += strlen(separator);
    } else
	    *str = '\0';
    *len = strlen(str);
    return q;
}

int rtab_status(char *packed, char *stsmsg) {
	char *buf;
	int mtype, size;

	buf = packed;
	buf = fetch_int(buf, &mtype);
	buf = fetch_str(buf, stsmsg, &size);
	return mtype;
}

Rtab *rtab_unpack(char *packed, int len) {
	Rtab *results;
	char *buf, *p;
	char tmpbuf[1024];
	int mtype, size, ncols, nrows, i, j;
	
	debugf("Unpacking RTAB\n");
	i = len;			/* eliminate unused warning */
	results = rtab_new();
	buf = packed;
	p = strchr(buf, '\n');
	*p++ = '\0';
	buf = fetch_int(buf, &mtype);
	buf = fetch_str(buf, tmpbuf, &size);
	buf = fetch_int(buf, &ncols);
	buf = fetch_int(buf, &nrows);
	results->mtype = mtype;
	results->msg = (char *)error_msgs[mtype];
	results->nrows = nrows;
	results->ncols = ncols;
	debugf("RTAB MESSAGE TYPE: %d\n", results->mtype);
	debugf("RTAB MESSAGE: %s\n", results->msg);
	debugf("RTAB NCOLS: %d\n", results->ncols);
	debugf("RTAB NROWS: %d\n", results->nrows);
	if (nrows > 0) {
		results->coltypes = (int **)mem_alloc(ncols * sizeof(int *));
		results->colnames = (char **)mem_alloc(ncols * sizeof(char *));
		buf = p;
		p = strchr(buf, '\n');
		*p++ = '\0';
		for (i = 0; i < ncols; i++) {
			char *cname, *ctype;
			int index;
			buf = fetch_str(buf, tmpbuf, &size);
			ctype = tmpbuf;
			cname = strchr(tmpbuf, ':');
			*cname++ = '\0';
			index = typetable_index(ctype);
			results->coltypes[i] = &primtype_val[index];
			results->colnames[i] = str_dupl(cname);
		}
		results->rows = (Rrow **)mem_alloc(nrows * sizeof(Rrow *));
		for (j = 0; j < nrows; j++) {
			Rrow *row;
			buf = p;
			p = strchr(buf, '\n');
			*p++ = '\0';
			row = (Rrow *)mem_alloc(sizeof(Rrow));
			results->rows[j] = row;
			row->cols = (char **)mem_alloc(ncols * sizeof(char *));
			for (i = 0; i < ncols; i++) {
				buf = fetch_str(buf, tmpbuf, &size);
				row->cols[i] = str_dupl(tmpbuf);
			}
			if ((p-packed) >= len) {
				results->nrows = j + 1;
				break;
			}
		}
	}
	
	return results;
}


int rtab_send(Rtab *results, RpcConnection outgoing) {
	char packed[SOCK_RECV_BUF_LEN];
	char resp[100];
	int len;
        unsigned rlen;
	
	debugf("Sending rtab\n");
		
	/* Send dummy empty results */
	if (!results) {
		debugvf("Rtab is empty.\n");
		strcpy(packed, RTAB_EMPTY);
		len = RTAB_EMPTY_LEN;
	} else
		(void )rtab_pack(results, packed, SOCK_RECV_BUF_LEN, &len);
	
	return rpc_call(outgoing, packed, len, resp, sizeof(resp), &rlen);	
}

/* ----------------[ Manipulator methods ] ---------------- */

static int rtab_global_col;

int cmp_rrow_by_col(const void *a, const void *b) {
	
	Rrow *ra;
	Rrow *rb;
	int col_in_a;
	int col_in_b;
	char **cols_a;
	char **cols_b;
	
	ra = (Rrow *) a;
	rb = (Rrow *) b;
	
	cols_a = (*ra).cols;
	cols_b = (*rb).cols;
	
	col_in_a = atoi(cols_a[rtab_global_col]);
	col_in_b = atoi(cols_b[rtab_global_col]);

	debugvf("cols_a: %p, cols_a[0]: %s\n", cols_a, cols_a[0]);
	
	return (col_in_a - col_in_b);
}

void rtab_orderby(Rtab *results, char *colname) {
	
	int i;
	int valid;
	
	if (colname == NULL) {
		debugvf("Rtab: No orderby in select. returning.\n");
		return;
	}
	
	debugf("Ordering results table by: %s...\n", colname);
	
	/* Check colname is valid */
	valid = -1;
	for (i = 0; i < results->ncols; i++) {
		if (strcmp(results->colnames[i], colname) == 0) {
			debugf("Order by column is valid, proceeding... (%s)\n", colname);
			valid = i;
			break;
		}
	}
	if (valid == -1) {
		debugf("Order by column is NOT valid\n");
		return;
	}
	
	/* Set global used by qsort */
	rtab_global_col = valid;
	
	/* DEBUG */
	for (i=0; i < results->nrows; i++) {
		debugvf("ptr results->rows[%d]->cols: %p, results->rows[%d]->cols[0]: %d\n",
		i, results->rows[i]->cols, 
		i, atoi(results->rows[i]->cols[0]));
	}
		
	qsort(results->rows, results->nrows, sizeof(Rrow), cmp_rrow_by_col);
}

void rtab_countstar(Rtab *results) {
	int count;
	//char *countstr;
	char countstr[100];
	char **newcolnames;
	int **newcoltypes;
	Rrow **newrows;
	Rrow *row;
	
	debugf("rtab_countstar...\n");
	
	if (results->nrows < 1)
		return;
	
	//countstr = mem_alloc(sizeof(char)*100);
	//(void) memset((void *)countstr, 0, sizeof(char)*100);
	
	count = results->nrows;
	sprintf(countstr, "%d", count);
	
	rtab_purge(results);
	results->nrows = 1;
	results->ncols = 1;
	
	newcolnames = mem_alloc(sizeof(char*));
	newcolnames[0] = str_dupl("count(*)");
	results->colnames = newcolnames;
	
	newcoltypes = mem_alloc(sizeof(int*));
	//newcoltypes[0] = (int *)mem_alloc(sizeof(int));
	newcoltypes[0] = PRIMTYPE_INTEGER;	
	results->coltypes = newcoltypes;
	
	newrows = (Rrow **)mem_alloc(sizeof(Rrow*));
	row = (Rrow *)mem_alloc(sizeof(Rrow));
	newrows[0] = row;
	row->cols = (char **)mem_alloc(sizeof(char *));
	row->cols[0] = str_dupl(countstr);
	results->rows = newrows;
	
}

char *rtab_process_min(Rtab *results, int col) {
	
    int r;
    int min, ti;
    char **row;
    char tb[100];
    double rmin, tr;
    int *pt;
    int isint;
    
    debugf("Rtab: process min\n");
    
    pt = results->coltypes[col];
    if (pt == PRIMTYPE_INTEGER ||
        pt == PRIMTYPE_TINYINT || pt == PRIMTYPE_SMALLINT)
	isint = 1;
    else  if (pt == PRIMTYPE_REAL)
	isint = 0;
    else {
	return str_dupl("undefined");
    }
    min = 0;
    rmin = 0.0;
    if (results->nrows > 0) {
	
	/* Init value */
	row = rtab_getrow(results, 0);
	if (isint)
	    min = atoi(row[col]);
	else
	    rmin = atof(row[col]);
	
	/* Loop through rest */
	for (r=1; r<results->nrows; r++) {
	    row = rtab_getrow(results, r);
	    if (isint) {
	        ti = atoi(row[col]);
	        if (min > ti)
	    	    min = ti;
	    } else {
	        tr = atof(row[col]);
	        if (rmin > tr)
	    	    rmin = tr;
	    }
	}
    }
    if (isint)
        sprintf(tb, "%d", min);
    else
	sprintf(tb, "%f", rmin);
    return str_dupl(tb);
}

char *rtab_process_max(Rtab *results, int col) {

    int r;
    int max, ti;
    char **row;
    char tb[100];
    double rmax, tr;
    int *pt;
    int isint;
    
    debugf("Rtab: process max\n");

    pt = results->coltypes[col];
    if (pt == PRIMTYPE_INTEGER ||
        pt == PRIMTYPE_TINYINT || pt == PRIMTYPE_SMALLINT)
	isint = 1;
    else  if (pt == PRIMTYPE_REAL)
	isint = 0;
    else {
	return str_dupl("undefined");
    }
    max = 0;
    rmax = 0.0;
    if (results->nrows > 0) {
	
	/* Init value */
	row = rtab_getrow(results, 0);
	if (isint)
	    max = atoi(row[col]);
	else
	    rmax = atof(row[col]);
	
	/* Loop through rest */
	for (r=1; r<results->nrows; r++) {
	    row = rtab_getrow(results, r);
	    if (isint) {
		ti = atoi(row[col]);
	        if (max < ti)
	    	    max = ti;
	    } else {
		tr = atof(row[col]);
		if (rmax < tr)
		    rmax = tr;
	    }
	}
    }
    if (isint)
        sprintf(tb, "%d", max);
    else
	sprintf(tb, "%f", rmax);
    return str_dupl(tb);
}

char *rtab_process_avg(Rtab *results, int col) {
    int r;
    char **row;
    unsigned int count;
    double average, x;
    char tb[100];
    int *pt;
    int isint;
    
    debugf("Rtab: process avg\n");

    pt = results->coltypes[col];
    if (pt == PRIMTYPE_INTEGER ||
        pt == PRIMTYPE_TINYINT || pt == PRIMTYPE_SMALLINT)
	isint = 1;
    else  if (pt == PRIMTYPE_REAL)
	isint = 0;
    else {
	return str_dupl("undefined");
    }
    average = 0.0;
    if (results->nrows > 0) {
	
	/* Init value */
	row = rtab_getrow(results, 0);
	count = 1;
	if (isint)
	    average = (double)atoi(row[col]);
	else
	    average = atof(row[col]);
	
	/* Loop through rest */
	for (r=1; r<results->nrows; r++) {
	    row = rtab_getrow(results, r);
	    if (isint)
		x = (double)atoi(row[col]);
	    else
		x = atof(row[col]);
	    average = (x + (double)count * average)/(double)(++count);
	}
    }
    if (isint)
        sprintf(tb, "%d", (int)average);
    else
	sprintf(tb, "%f", average);
    return str_dupl(tb);
}

char *rtab_process_sum(Rtab *results, int col) {

    int r;
    int sum;
    char **row;
    char tb[100];
    double rsum;
    int *pt;
    int isint;
    
    debugf("Rtab: process min\n");
    pt = results->coltypes[col];
    if (pt == PRIMTYPE_INTEGER ||
        pt == PRIMTYPE_TINYINT || pt == PRIMTYPE_SMALLINT)
	isint = 1;
    else  if (pt == PRIMTYPE_REAL)
	isint = 0;
    else {
	return str_dupl("undefined");
    }
    sum = 0;
    rsum = 0.0;
    if (results->nrows > 0) {
	
	/* Loop through the rows */
	for (r=0; r<results->nrows; r++) {
	    row = rtab_getrow(results, r);
	    if (isint)
		sum += atoi(row[col]);
	    else
		rsum += atof(row[col]);
	}
    }
    if (isint)
        sprintf(tb, "%d", sum);
    else
	sprintf(tb, "%f", rsum);
    return str_dupl(tb);
	
}

void rtab_to_onerow_if_no_others(Rtab *results) {
	int i, j;
	debugf("Rtab: to onerow (if no others)\n");
	
	/*
	 * all selected columns have been min/max/avg/sum'ed
	 * therefore, the colnames and coltypes are correct
	 * rows[0] has the data, rows[1] ... rows[results->nrows-1] are
	 * superfluous, so need to be freed
	 */
        for (i = 1; i < results->nrows; i++) {
                for (j = 0; j < results->ncols; j++)
                        mem_free(results->rows[i]->cols[j]);
                mem_free(results->rows[i]);
        }
	results->nrows = 1;
}

void rtab_processMinMaxAvgSum(Rtab *results, int** colattrib) {
	
	int c;
	char *ret;
	int has_non_minMaxAvgSum;
	
	debugf("Rtab: Processing min, max, avg, sum\n");
	
	if (results->nrows < 1)
		return;
	
	has_non_minMaxAvgSum = 0;
	
	for (c = 0; c < results->ncols; c++) {
		if (*colattrib[c] == *SQL_COLATTRIB_MIN) {
			ret = rtab_process_min(results, c);
			printf("Min col %d: %s\n", c, ret);
			rtab_replace_col_val(results, c, ret);
			rtab_update_colname(results, c, "min");
		}
		
		else if (*colattrib[c] == *SQL_COLATTRIB_MAX) {
			ret = rtab_process_max(results, c);
			printf("Max col %d: %s\n", c, ret);
			rtab_replace_col_val(results, c, ret);
			rtab_update_colname(results, c, "max");
		}
		
		else if (*colattrib[c] == *SQL_COLATTRIB_AVG) {
			ret = rtab_process_avg(results, c);
			printf("Avg col %d: %s\n", c, ret);
			rtab_replace_col_val(results, c, ret);
			rtab_update_colname(results, c, "avg");
		}
		
		else if (*colattrib[c] == *SQL_COLATTRIB_SUM) {
			ret = rtab_process_sum(results, c);
			printf("Sum col %d: %s\n", c, ret);
			rtab_replace_col_val(results, c, ret);
			rtab_update_colname(results, c, "sum");
		}
		
		else if (*colattrib[c] == *SQL_COLATTRIB_NONE) {
			has_non_minMaxAvgSum = 1;
		}
		
	}
	
	
	/* Reduce to one row if all of them are minMaxAvgSum */
	if (has_non_minMaxAvgSum == 0) {
		rtab_to_onerow_if_no_others(results);
	}
	
}

void rtab_replace_col_val(Rtab *results, int c, char *val) {
	
	int r;
	char **row;
	
	debugf("Rtab replacing col val\n");
	
	for (r = 0; r < results->nrows; r++) {
		row = rtab_getrow(results, r);
		mem_free(row[c]);
		row[c] = str_dupl(val);
	}
	mem_free(val);
	
}

void rtab_update_colname(Rtab *results, int c, char *prefix) {
	
	//char *fullname;
	char fullname[100];
	
	debugf("Rtab: update colname\n");
	
	//fullname = mem_alloc(sizeof(char)*100); /* TODO: tidy */
	//(void) memset((void *)fullname, 0, 100);
	sprintf(fullname, "%s(%s)", prefix, results->colnames[c]);
	
	//results->colnames[c] = fullname;
	mem_free(results->colnames[c]);
	results->colnames[c] = str_dupl(fullname);
	
}

/* For debugging purposes */
Rtab *rtab_fake_results() {
	Rtab *results;
	int i,j;
	
	results = rtab_new();
	
	results->ncols = 3;
	results->nrows = 3;
	results->coltypes = mem_alloc(results->ncols * sizeof(int*));
	results->colnames = mem_alloc(results->ncols * sizeof(char*));
	results->rows = mem_alloc(results->nrows * sizeof(Rrow*));
	for (i=0; i<results->nrows; i++) {
		results->rows[i] = mem_alloc(sizeof(Rrow));
		results->rows[i]->cols = mem_alloc(results->ncols * sizeof(char*));
	}
	
	for (i=0; i < results->ncols; i++) {
		results->coltypes[i] = PRIMTYPE_VARCHAR;
		results->colnames[i] = "Whatever";
		for (j=0; j < results->nrows; j++) {
			results->rows[j]->cols[i] = "Hmm";
		}
	}
	
	return results;
}

