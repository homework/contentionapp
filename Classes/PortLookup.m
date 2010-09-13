//
//  PortLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 03/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PortLookup.h"


@implementation PortLookup


static int  number = 1;
static NSString* udplookup[50000];
static NSString* tcplookup[50000];

+(void) initPorts{
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
	if (port > -1 && port < 50000){
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




/*
+(void) initialize {
	
	[self loadPortNumbers:@"udp_port" array:udplookup];
	[self loadPortNumbers:@"tcp_port" array:tcplookup];
}

+(void) loadPortNumbers:(NSString *) name array:(NSString *[]) array{
	
	//prefill array will nulls
	
	for (int i = 0; i < 50000; i++){
		array[i] = NULL;
	}
	
	NSString *tmp;
    NSArray *lines;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    while(tmp = [nse nextObject]) {
		NSString *portnumber = nil;
		NSString *protocol = nil;
        NSScanner *scanner = [NSScanner scannerWithString:tmp];
        [scanner scanUpToString:@"\t" intoString:&portnumber];
		[scanner scanUpToString:@"\n" intoString:&protocol];
		array[[portnumber intValue]] = [[NSString stringWithFormat:@"%@", protocol] retain];
    }
	
}

+(NSString *) lookup:(int) port protocol:(int) proto{
	if (port > -1 && port < 50000){
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
*/

@end
