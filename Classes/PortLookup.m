//
//  PortLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 03/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PortLookup.h"


@implementation PortLookup


static NSString* udplookup[50000];
static NSString* tcplookup[50000];
static BOOL init = FALSE;

+(void) initPorts{
	
	if (init)
		return;
	
	init = TRUE;
	
	for (int i = 0; i < 50000; i++){
		udplookup[i] = NULL;
		tcplookup[i] = NULL;
	}
	
	NSString *tmp;
    NSArray *lines;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"udp_port" ofType:@"txt"];
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
   	
    while(tmp = [nse nextObject]) {
		NSString *portnumber = nil;
		NSString *protocol = nil;
        NSScanner *scanner = [NSScanner scannerWithString:tmp];
        [scanner scanUpToString:@"\t" intoString:&portnumber];
		[scanner scanUpToString:@"\n" intoString:&protocol];
		udplookup[[portnumber intValue]] = [[NSString stringWithFormat:@"%@", protocol] retain];
    }
	
	filePath = [[NSBundle mainBundle] pathForResource:@"tcp_port" ofType:@"txt"];
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
    nse = [lines objectEnumerator];
    
	
    while(tmp = [nse nextObject]) {
		NSString *portnumber = nil;
		NSString *protocol = nil;
        NSScanner *scanner = [NSScanner scannerWithString:tmp];
        [scanner scanUpToString:@"\t" intoString:&portnumber];
		[scanner scanUpToString:@"\n" intoString:&protocol];
		tcplookup[[portnumber intValue]] = [[NSString stringWithFormat:@"%@", protocol] retain];
	}
	
}


+(NSString *)lookup:(unsigned short) port protocol:(unsigned short) proto {
	//NSLog(@"looking up port %hu protocol %d", port, proto);
	if (port < 50000){
		if (proto == 6) // TCP
		{
			return tcplookup[port];
		}	
		else if (proto == 17){
			return udplookup[port];
		}	
	}
	return NULL;
}

+(void) dealloc{
	for (int i =0; i < 50000; i++){
		if (udplookup[i] != NULL)
			[udplookup[i] release];
		if (tcplookup[i] != NULL)
			[tcplookup[i] release];
	}
	[super dealloc];
	
}
@end
