//
//  FlowObject.m
//  ActivityMonitor
//
//  Created by Tom Lodge on 24/03/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlowObject.h"


@implementation FlowObject

@synthesize packets;
@synthesize bytes;
@synthesize ip_src;
@synthesize ip_dst;
@synthesize sport;
@synthesize dport;
@synthesize proto;

-(id) initWithFlow: (FlowData *) f{
	if (self = [super init])
	{
		proto = f->proto;
		ip_src = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", inet_ntoa(f->ip_src)]];//, inet_ntoa(f->ip_src)];
		ip_dst = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", inet_ntoa(f->ip_dst)]];//, inet_ntoa(f->ip_dst)];
		//memcpy(&ip_src, &f->ip_src, sizeof(struct in_addr));
		//memcpy(&ip_dst, &f->ip_dst, sizeof(struct in_addr));
		sport = f->sport;
		dport = f->dport;
		packets = f->packets;
		bytes = f->bytes;
		tstamp = f->tstamp;
	}
	return self;
}

-(id) initSynthetic:(NSString *) from to:(NSString *) to{
	int tcpports[] = {21,22,443,8080,1935};
	int udpports[] = {987,988,25,22};
	
	int protos[] = {6,17}; /*tcp, udp*/
	
	if (self = [super init])
	{
		ip_src = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%@", from]];
		ip_dst = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%@", to]];
	    //create a fake ip_src address;
		//inet_aton("128.34.234.56", &ip_src);
		//inet_aton("128.234.234.5", &ip_dst);
		
		proto = protos[arc4random() % 2];
		if (proto == 6){
			sport = dport = tcpports[arc4random() % 6];
		}else{
			sport = dport = udpports[arc4random() % 6];

		}
		//sport = arc4random() % 5000;
		//dport =arc4random() % 5000;
		packets =  arc4random() % 1000;
		bytes  = arc4random() % 200000;
		//gettimeofday(&tstamp, NULL);
		
	}
	return self;
}

-(id)init
{
	return [self initWithFlow:nil];
}

-(void) print{
	NSLog(@"%u:%08lx:%08lx:%d:%d:%lu:%lu", proto,
		  ip_src, ip_dst, sport, dport, packets,
		  bytes);
}

-(void) dealloc{
	[ip_src release];
	[ip_dst release];
	[super dealloc];
}

@end
