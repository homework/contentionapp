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
    unsigned char proto;
    struct in_addr ip_src;
    struct in_addr ip_dst;
    unsigned short sport;
    unsigned short dport;
    unsigned long packets;
    unsigned long bytes;
    tstamp_t tstamp;
} FlowData;

@interface FlowObject : NSObject {
	unsigned char proto;
	NSString *ip_src;
	NSString *ip_dst;
	unsigned short sport;
	unsigned short dport;
	unsigned long packets;
	unsigned long bytes;
	tstamp_t tstamp;
	
}


@property(nonatomic,assign) unsigned char proto;
@property(nonatomic,assign) unsigned long packets;
@property(nonatomic,assign) unsigned long bytes;
@property(nonatomic,assign) unsigned short sport;
@property(nonatomic,assign) unsigned short dport;

@property(nonatomic,assign) NSString *ip_src;
@property(nonatomic,assign) NSString *ip_dst;

-(id) initWithFlow: (FlowData *) flowData;
-(id) initSynthetic: (NSString *) from to:(NSString *) to;
@end
