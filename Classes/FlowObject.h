//
//  FlowObject.h
//  ActivityMonitor
//
//  Created by Tom Lodge on 24/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <netinet/ip.h>	
#include "timestamp.h"
#include <sys/time.h>



typedef struct flow_data {
    tstamp_t t;
    unsigned char proto;
    struct in_addr ip_src;
    struct in_addr ip_dst;
    unsigned short sport;
    unsigned short dport;
    unsigned long packets;
    unsigned long bytes;
    unsigned char flags;
    tstamp_t tstamp;
} FlowData;

@interface FlowObject : NSObject {
    tstamp_t t;
	unsigned char proto;
	NSString *ip_src;
	NSString *ip_dst;
	unsigned short sport;
	unsigned short dport;
	unsigned long packets;
	unsigned long bytes;
    unsigned char flags;
	tstamp_t tstamp;
	
}


@property(nonatomic,assign) unsigned char proto;
@property(nonatomic,assign) unsigned long packets;
@property(nonatomic,assign) unsigned long bytes;
@property(nonatomic,assign) unsigned short sport;
@property(nonatomic,assign) unsigned short dport;

@property(nonatomic,retain) NSString *ip_src; //WHY NOT RETAIN??
@property(nonatomic,retain) NSString *ip_dst; //WHY NOT RETAIN??

-(id) initWithFlow: (FlowData *) flowData;
-(id) initSynthetic: (NSString *) from to:(NSString *) to;
@end
