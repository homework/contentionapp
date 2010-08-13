/**
 * Timestamp
 * 
 */
#include "timestamp.h"
#include "mem.h"
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

extern int daylight;
extern long timezone;

tstamp_t timestamp_now(void) {
	struct timeval tv;

	gettimeofday(&tv, NULL);
	return timeval_to_timestamp(&tv);
}

char *timestamp_to_string(tstamp_t ts) {
	char b[64], *s;
	sprintf(b, "@%016llx@", ts & ~DROPPED);	/* ignore dropped bit if set */
	s = str_dupl(b);
	return s;
}

tstamp_t string_to_timestamp(char *s) {
	tstamp_t ts;

	ts = strtoull(s+1, NULL, 16);	/* skip over leading @ */
	return ts;
}

tstamp_t timeval_to_timestamp(struct timeval *tv) {
	tstamp_t ts;

	ts = 1000 *
	     (1000000 * (tstamp_t)(tv->tv_sec) + (tstamp_t)(tv->tv_usec));
	return ts;
}

void timestamp_to_timeval(tstamp_t ts, struct timeval *tv) {
	tv->tv_usec = (unsigned long)(ts % 1000000000LL) / 1000;
	tv->tv_sec = (unsigned long) (ts / 1000000000LL);
}

tstamp_t timestamp_add_incr(tstamp_t ts, unsigned long units, int ifmillis) {
	tstamp_t ans;
	unsigned long long mult;

	mult = (ifmillis) ? 1000000LL : 1000000000LL;
	ans = ts + mult * (unsigned long long)units;
	return ans;
}

/*
 * converts date string to a timestamp
 *
 * datestring is of the form: YYYY/MM/DD:hh:mm:ss
 *
 * YYYY must be >= 1970; if not, it is set to 1970
 * MM must be >= 1 and <= 12; if not, it is set to 1
 * DD must be >= 1 and <= 31; if not, it is set to 1
 * hh must be >= 0 and <= 23; if not, it is set to 0
 * mm must be >= 0 and <= 59; if not, it is set to 0
 * ss must be >= 0 and <= 61; if not, it is set to 0
 * (note, ss = 60 or ss = 61 are when accounting for leap seconds)
 */

tstamp_t datestring_to_timestamp(char *s) {
    struct timespec ts;
    struct tm tmv;
    int year, month, day, hh, mm, ss;
    int save_daylight = daylight;
    long save_timezone = timezone;

    sscanf(s, "%d/%d/%d:%d:%d:%d", &year, &month, &day, &hh, &mm, &ss);
    tmv.tm_year = (year >= 1970) ? year - 1900 : 70;
    tmv.tm_mon = (month > 0 && month < 13) ? month - 1 : 0;
    tmv.tm_mday = (day > 0 && day < 32) ? day : 1;
    tmv.tm_hour = (hh >= 0 && hh < 24) ? hh : 0;
    tmv.tm_min = (mm >= 0 && mm < 60) ? mm : 0;
    tmv.tm_sec = (ss >= 0 && ss < 62) ? ss : 0;
    tmv.tm_isdst = 0;
    daylight = 0;
    timezone = 0;
    ts.tv_sec = mktime(&tmv);
    ts.tv_nsec = 0;
    daylight = save_daylight;
    timezone = save_timezone;
    return timeval_to_timestamp((struct timeval *)&ts);
}

char *timestamp_to_datestring(tstamp_t ts) {
    char buf[64];
    struct timeval tv;
    struct tm tmv;
    int save_daylight;
    long save_timezone;

    timestamp_to_timeval(ts, &tv);
    save_daylight = daylight; daylight = 0;
    save_timezone = timezone; timezone = 0;
    (void) gmtime_r(&tv.tv_sec, &tmv);
    daylight = save_daylight;
    timezone = save_timezone;
    sprintf(buf, "%4d/%02d/%02d:%02d:%02d:%02d", tmv.tm_year+1900, tmv.tm_mon+1,
            tmv.tm_mday, tmv.tm_hour, tmv.tm_min, tmv.tm_sec);
    return str_dupl(buf);
}
