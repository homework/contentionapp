//
//  PollingThread.m
//  ActivityMonitor
//
//  Created by Tom Lodge on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PollingThread.h"


#define TIME_DELTA 5		/* in seconds */

static struct timespec time_delay = {TIME_DELTA, 0};
static tstamp_t processflowresults(char *buf, unsigned int len);
static tstamp_t processlinkresults(char *buf, unsigned int len);
static tstamp_t processleaseresults(char *buf, unsigned int len);
static tstamp_t processdevicenameresults(char *buf, unsigned int len);

static uint64_t string_to_mac(char *s);


/*
 * function pointer which will be the callback from a poll.
 */
static tstamp_t (*callback) (char *buf, unsigned int len);

@interface PollingThread (PrivateMethods)
-(void) poll;
-(int) polllinktable;
-(int) pollleasetable;
-(int) pollflowtable;
-(int) polldevicetable;

-(int) polldatabase:(tstamp_t*)last;
+(void) postNotification:(FlowObject *)f;

@end


static tstamp_t lastflow;
static tstamp_t lastlink;
static tstamp_t lastlease;
static tstamp_t lastdevice;

@implementation PollingThread
@synthesize delegate;

-(id) init{
	if (self = [super init]) {
		lastflow = 0LL;
		lastlink = 0LL;
		lastlease = 0LL;
        lastdevice = 0LL;
	}
	return self;
}

-(void) startpolling: (id) anObject{
	NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
	[self poll];
	[apool release];
}

-(void) setDelegate:(DeviceViewController *) vc{
	
	delegate = vc;
}

-(void) poll{
	
	
	for(;;){	
		
		gettimeofday(&expected, NULL);
		expected.tv_usec = 0;
		
		for (;;){
			
			[PollingThread performSelectorOnMainThread:@selector(newPoll:) withObject:nil waitUntilDone:YES];
			
			if (![self pollleasetable]){
				break;
			}
			
			if (![self pollflowtable]){
				break;
			}
            
            if (![self polldevicenametable]){
				break;
			}
			
			expected.tv_sec += TIME_DELTA;
			gettimeofday(&current, NULL);
			
			if (current.tv_usec > 0) {
				time_delay.tv_nsec = 1000 * (1000000 - current.tv_usec);
				time_delay.tv_sec = expected.tv_sec - current.tv_sec - 1;
			} else {
				time_delay.tv_nsec = 0;
				time_delay.tv_sec = expected.tv_sec - current.tv_sec;
			}
			
			[PollingThread performSelectorOnMainThread:@selector(pollComplete:) withObject:nil waitUntilDone:YES];
			nanosleep(&time_delay, NULL);
		}
		
		time_delay.tv_sec += TIME_DELTA;
		time_delay.tv_nsec = 0;
		nanosleep(&time_delay, NULL);
		
	}
	exit(0);
}


-(int) polldevicenametable{
    if (lastdevice){
        char *s = timestamp_to_string(lastdevice);
		DLog(@"SQL:select * from DeviceNames [ since %s ]", s);
		sprintf(query, "SQL:select * from DeviceNames [ since %s ]\n",s);
		free(s);
    }else{
        DLog(@"device names query is SQL:select * from DeviceNames",
             TIME_DELTA);
		
		sprintf(query,
				"SQL:select * from DeviceNames\n",
				TIME_DELTA);
        
    }   
    
    callback = &processdevicenameresults;
	
	int success = [self polldatabase:&lastdevice];
	
	if (success && lastdevice){
		return 1;
	}
	
	return success;
}


-(int) pollflowtable{
	
	if (lastflow) {
		char *s = timestamp_to_string(lastflow);
		DLog(@"SQL:select * from KFlows [ since %s ]", s);
		sprintf(query, "SQL:select * from KFlows [ since %s ]\n",s);
		free(s);
	} else{
		DLog(@"flow query is SQL:select * from KFlows [ range %d seconds]",
			  TIME_DELTA);
		
		sprintf(query,
				"SQL:select * from KFlows [ range %d seconds]\n",
				TIME_DELTA);
	}
	
	callback = &processflowresults;
	
	int success = [self polldatabase:&lastflow];
	
	if (success && lastflow){
		return 1;
	}
	
	
	return success;
}

-(int) pollleasetable{
	
	if (lastlease) {
		char *s = timestamp_to_string(lastlease);
		DLog(@"SQL:select * from Leases [ since %s ]",s);
		sprintf(query,
				"SQL:select * from Leases [since %s]\n", s);
		free(s);
	} else{
		DLog(@"SQL:select * from Leases\n");
		
		sprintf(query,
				"SQL:select * from Leases\n");
	}
	
	callback = &processleaseresults;
	int success = [self polldatabase:&lastlease];
	
	if (success && lastlease){
		return 1;
	}
	
	return success;
}

-(int) polllinktable{
	
	
	if (lastlink) {
		char *s = timestamp_to_string(lastlink);
		sprintf(query,
				"SQL:select * from Links [ range %d seconds] where timestamp > %s\n",
				TIME_DELTA+1, s);
		free(s);
	} else{
		sprintf(query,
				"SQL:select * from Links [ range %d seconds]\n",
				TIME_DELTA);
	}
	
	callback = &processlinkresults;
	int success = [self polldatabase:&lastlink];
	
	if (success && lastlink){
		return 1;
	}
	
	return success;
}


-(int) polldatabase:(tstamp_t *) last{
	
	qlen = strlen(query) + 1;
	
	
	if (![RPCSend send: query qlen:qlen resp:resp rsize:sizeof(resp) len:&len]) {	
		fprintf(stderr, "rpc_call() failed\n");
		DLog(@"rpc call failed");
		*last = 0LL;
		return 0;
	}
	resp[len] = '\0';
	*last = callback(resp, len);
	return 1;
}

void dhcp_free(DhcpResults *p) {
	unsigned int i;
	
    if (p) {
        for (i = 0; i < p->nleases && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);	
        free(p);
    }
}


DhcpResults *dhcp_convert(Rtab *results) {
	DhcpResults *ans;
	unsigned int i;
	
	if (! results || results->mtype != 0)
		return NULL;
	if (!(ans = (DhcpResults *)malloc(sizeof(DhcpResults))))
		return NULL;
	
	ans->nleases = results->nrows;
	ans->data    = (DhcpData **)calloc(ans->nleases, sizeof(DhcpData *));
	
	if (!ans->data){
		free(ans);
		return NULL;
	}
	
	for (i = 0; i < ans->nleases; i++) {
		char **columns;
		DhcpData *p = (DhcpData *)malloc(sizeof(DhcpData));
		
		if (!p) {
            dhcp_free(ans);
			return NULL;
		}
		ans->data[i] = p;
		columns = rtab_getrow(results, i);
		/* populate record */
		p->tstamp = string_to_timestamp(columns[0]);
        p->mac_addr = string_to_mac(columns[1]);
        inet_aton(columns[2], (struct in_addr *)&p->ip_addr);
        strncpy(p->hostname, columns[3], 70);
		p->action = action2index(columns[4]);
	}
	return ans;
}


LinkResults *link_mon_convert(Rtab *results) {
    LinkResults *ans;
    unsigned int i;
	
    if (! results || results->mtype != 0)
        return NULL;
    if (!(ans = (LinkResults *)malloc(sizeof(LinkResults))))
        return NULL;
    ans->nlinks = results->nrows;
    ans->data = (LinkData **)calloc(ans->nlinks, sizeof(LinkData *));
    if (! ans->data) {
        free(ans);
		return NULL;
    }
    for (i = 0; i < ans->nlinks; i++) {
        char **columns;
        LinkData *p = (LinkData *)malloc(sizeof(LinkData));
		if (!p) {
            link_mon_free(ans);
			return NULL;
		}
		ans->data[i] = p;
		columns = rtab_getrow(results, i);
		p->tstamp = string_to_timestamp(columns[0]);
		p->mac = string_to_mac(columns[1]);
		p->rss = atof(columns[2]);
		p->retries = atoi(columns[3]);
		p->packets = atol(columns[4]);
		p->bytes = atol(columns[5]);
    }
    return ans;
}

uint64_t string_to_mac(char *s) {
    int b[6], i;
    uint64_t ans;
	
    sscanf(s, "%02x:%02x:%02x:%02x:%02x:%02x",
		   &b[0], &b[1], &b[2], &b[3], &b[4], &b[5]);
    ans = 0LL;
    for (i = 0; i < 6; i++)
        ans = ans << 8 | (b[i] & 0xff);
    return ans;
}


void link_mon_free(LinkResults *p) {
    unsigned int i;
	
    if (p) {
        for (i = 0; i < p->nlinks && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);
        free(p);
    }
}



DeviceNameResults *devicename_mon_convert(Rtab *results){
    DeviceNameResults *ans;
    unsigned int i;
	
    if (! results || results->mtype != 0){
		return NULL;
	}
    if (!(ans = (DeviceNameResults *)malloc(sizeof(DeviceNameResults)))){
		return NULL;
	}
    ans->ndevices = results->nrows;
    ans->data = (DeviceNameData **)calloc(ans->ndevices, sizeof(DeviceNameData *));
	
	if (! ans->data) {
        free(ans);
		return NULL;
    }
    for (i = 0; i < ans->ndevices; i++) {
        char **columns;
        DeviceNameData *p = (DeviceNameData *)malloc(sizeof(DeviceNameData));
		if (!p) {
            devicename_mon_free(ans);
			return NULL;
		}
		ans->data[i] = p;
		columns = rtab_getrow(results, i);
        /* hwdb's timestamp */
		p->tstamp = string_to_timestamp(columns[0]);
        /* logger's timestamp */
		inet_aton(columns[1], (struct in_addr *)&p->ip_addr);
        strncpy(p->name, columns[2], 256);
	}
	
    return ans;
}


void devicename_mon_free(DeviceNameResults *p){
    unsigned int i;
	
    if (p) {
        for (i = 0; i < p->ndevices && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);
        free(p);
    }

}
/*
 * converts the returned Flows tuples into a dynamically-allocated array
 * of FlowData structures.  after the user is finished with the array,
 * mon_free should be called to return the storage to the heap
 *
 * Assumes that the Flow tuple is as defined by hwdb.rc - i.e.
 *
 * create table Flows (proto integer, saddr varchar(16), sport integer,
 * daddr varchar(16), dport integer, npkts integer, nbytes integer)
 */
BinResults *mon_convert(Rtab *results) {
    BinResults *ans;
    unsigned int i;
	
    if (! results || results->mtype != 0){
		return NULL;
	}
    if (!(ans = (BinResults *)malloc(sizeof(BinResults)))){
		return NULL;
	}
    ans->nflows = results->nrows;
    ans->data = (FlowData **)calloc(ans->nflows, sizeof(FlowData *));
	
	if (! ans->data) {
        free(ans);
		return NULL;
    }
    for (i = 0; i < ans->nflows; i++) {
        char **columns;
        FlowData *p = (FlowData *)malloc(sizeof(FlowData));
		if (!p) {
            mon_free(ans);
			return NULL;
		}
		ans->data[i] = p;
		columns = rtab_getrow(results, i);
        /* hwdb's timestamp */
		p->tstamp = string_to_timestamp(columns[0]);
        /* logger's timestamp */
		p->t = string_to_timestamp(columns[1]);
        /* flow's key */
        p->proto = atoi(columns[2]) & 0xff;
		inet_aton(columns[3], (struct in_addr *)&p->ip_src);
		p->sport = atoi(columns[4]) & 0xffff;
		inet_aton(columns[5], (struct in_addr *)&p->ip_dst);
		p->dport = atoi(columns[6]) & 0xffff;
		/* flow's stats */
		p->packets = atol(columns[7]);
		p->bytes = atol(columns[8]);
		p->flags = atoi(columns[9]) & 0xff;
	}
	
    return ans;
}

void mon_free(BinResults *p) {
    unsigned int i;
	
    if (p) {
        for (i = 0; i < p->nflows && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);
        free(p);
    }
}

+(void) postLeaseObject:(LeaseObject *)l{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newLeaseDataReceived" object:l];	
}

+(void) postFlowObject:(FlowObject *)f{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newFlowDataReceived" object:f];
}

+(void) postDeviceNameObject:(DeviceNameObject *)d{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newDeviceDataReceived" object:d];
}

+(void) newPoll:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newPoll" object:nil];
}

+(void) pollComplete:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"pollComplete" object:nil];
}

+(void) connected:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"connected" object:nil];
}

+(void) disconnected:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"disconnected" object:nil];
}


static tstamp_t processleaseresults(char *buf, unsigned int len) {
	
	Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    DhcpResults *p;
    unsigned long i;
	
    tstamp_t last = lastlease;//timestamp_now(); 
	
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
		// rtab_print(results);
		p = dhcp_convert(results);
		// do something with the data pointed to by p 
		DLog(@"Retrieved %ld lease records from database\n", p->nleases);
		for (i = 0; i < p->nleases; i++) {
			DhcpData *l = p->data[i];
			DLog(@"the size is %d", strlen(l->hostname));
			
			char *s = timestamp_to_string(l->tstamp);
			char *a = strdup(inet_ntoa(*(struct in_addr *)&l->ip_addr));
			
			NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
			LeaseObject *lobj = [[LeaseObject alloc] initWithLease:l]; 
			[PollingThread performSelectorOnMainThread:@selector(postLeaseObject:) withObject:lobj waitUntilDone:YES];
			[lobj release];
			[autoreleasepool release];	
			
			DLog(@"[LEASERECORD] %s %s;%012llx;%s;%s\n", s, index2action(l->action), l->mac_addr, a, l->hostname);
			free(s);
			free(a);
		}
		if (i > 0) {
			i--;
			last = p->data[i]->tstamp;
		}
		dhcp_free(p);
    }
    rtab_free(results);
	
    return (last);
}



static tstamp_t processlinkresults(char *buf, unsigned int len) {
	
	Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
	LinkResults *p;
    unsigned long i;
    tstamp_t last = 0LL;
	
    results = rtab_unpack(buf, len);
    if (results && ! rtab_status(buf, stsmsg)) {
		// rtab_print(results);
		p = link_mon_convert(results);
		// do something with the data pointed to by p 
		DLog(@"Retrieved %ld link records from database\n", p->nlinks);
		for (i = 0; i < p->nlinks; i++) {
			LinkData *f = p->data[i];
			char *s = timestamp_to_string(f->tstamp);
			
			DLog(@"%s %012llx;%7.2f;%lu;%lu;%lu\n", s,
				  f->mac, f->rss, f->retries, f->packets, f->bytes);
			free(s);
		}
		if (i > 0) {
			i--;
			last = p->data[i]->tstamp;
		}
		link_mon_free(p);
    }
    rtab_free(results);
	
    return (last);
}


static tstamp_t processdevicenameresults(char *buf, unsigned int len) {
    Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    DeviceNameResults *p;
    unsigned long i;
    tstamp_t last = lastdevice;	
    results = rtab_unpack(buf, len);
    
    if (results && ! rtab_status(buf, stsmsg)) {
        p = devicename_mon_convert(results);
		// do something with the data pointed to by p 
		DLog(@"Retrieved %ld device name records from database", p->ndevices);
		
		for (i = 0; i < p->ndevices; i++) {
			DeviceNameData *dnd = p->data[i];
			char *s = timestamp_to_string(dnd->tstamp);
            char *a = strdup(inet_ntoa(*(struct in_addr *)&dnd->ip_addr));
			
			NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
			DeviceNameObject *dnobj = [[DeviceNameObject alloc] initWithDeviceNameData:dnd];
			
            DLog(@"[DEVICE NAME RECORD] %s %s %s \n", s, a, dnd->name);
			
			[PollingThread performSelectorOnMainThread:@selector(postDeviceNameObject:) withObject:dnobj waitUntilDone:YES];
			[dnobj release];
			[autoreleasepool release];		
			
			free(s);
		}
		if (i > 0) {
			i--;
			last = p->data[i]->tstamp;
		}
		devicename_mon_free(p);
    }
    rtab_free(results);
    return (last);
}

static tstamp_t processflowresults(char *buf, unsigned int len) {
	
    Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    BinResults *p;
    unsigned long i;
    tstamp_t last = 0LL;	
    results = rtab_unpack(buf, len);

	if (results && ! rtab_status(buf, stsmsg)) {
        p = mon_convert(results);
		// do something with the data pointed to by p 
		DLog(@"Retrieved %ld flow records from database", p->nflows);
		
		for (i = 0; i < p->nflows; i++) {
			FlowData *f = p->data[i];
			char *s = timestamp_to_string(f->tstamp);
			NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
			FlowObject *fobj = [[FlowObject alloc] initWithFlow:f];
			
//#ifdef CAPPDEBUG
//			if ([[NameResolver getidentifier:[fobj ip_src]] isEqualToString:@"001ff3bcb257"] ||
//				[[NameResolver getidentifier:[fobj ip_dst]] isEqualToString:@"001ff3bcb257"]){
			//	DLog(@"%@ %@ %d", [fobj ip_src], [fobj ip_dst],[fobj bytes]);
				
//			}
//#endif
			
			[PollingThread performSelectorOnMainThread:@selector(postFlowObject:) withObject:fobj waitUntilDone:YES];
			[fobj release];
			[autoreleasepool release];		
			
			free(s);
		}
		if (i > 0) {
			i--;
			last = p->data[i]->tstamp;
		}
		mon_free(p);
    }
    rtab_free(results);
    return (last);
}

@end
