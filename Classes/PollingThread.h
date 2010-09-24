//
//  PollingThread.h
//  ActivityMonitor
//
//  Created by Tom Lodge on 23/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "config.h"
#include "util.h"
#include "rtab.h"
#include "timestamp.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <netinet/ip.h>			/* defines in_addr */

#include "FlowObject.h"
#include "LinkObject.h"
#include "LeaseObject.h"
#include "DeviceViewController.h"
#include "RPCSend.h"

@interface PollingThread : NSObject {
	DeviceViewController *delegate;
	char query[SOCK_RECV_BUF_LEN];
	char resp[SOCK_RECV_BUF_LEN];
	int qlen;
	unsigned len;
	
	int i, j;
	struct timeval expected, current;
}



typedef struct bin_results {
    unsigned long nflows;
    FlowData **data;
} BinResults;

typedef struct link_results {
    unsigned long nlinks;
    LinkData **data;
} LinkResults;

typedef struct lease_results {
    unsigned long nleases;
    DhcpData **data;
} DhcpResults;
/*
 * convert Rtab results into LinkResults
 */
LinkResults *link_mon_convert(Rtab *results);

/*
 * free heap storage associated with LinkResults
 */
void link_mon_free(LinkResults *p);

/*
 * convert Rtab results into BinResults
 */
BinResults *mon_convert(Rtab *results);

/*
 * free heap storage associated with BinResults
 */
void mon_free(BinResults *p);

-(id) init;
-(void) startpolling:(id)anObject;
-(void) setDelegate:(DeviceViewController *) vc;
@property(nonatomic, assign) DeviceViewController* delegate;

@end
