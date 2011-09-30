//
//  PortLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 03/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PortLookup.h"

@interface PortLookup (PrivateMethods)
+(void) createTable: (NSString**) table path:(NSString*) path ftype:(NSString *) ftype;
@end

@implementation PortLookup


static NSString* udplookup[50000];
static NSString* tcplookup[50000];
static NSString* protolookup[143];
static BOOL init = FALSE;

+(void) initPorts{
	
	if (init)
		return;
	
	init = TRUE;
	
	for (int i = 0; i < 50000; i++){
		udplookup[i] = NULL;
		tcplookup[i] = NULL;
	}
	
	for (int i = 0; i < 143; i++){
		protolookup[i] = NULL;
	}
	
	[self createTable:udplookup path:@"udp_port" ftype:@"txt"];
	[self createTable:tcplookup path:@"tcp_port" ftype:@"txt"];
	[self createTable:protolookup path:@"protocol" ftype:@"txt"];
}

+(void) createTable: (NSString**) table path:(NSString*) path ftype:(NSString *) ftype{
	NSString *tmp;
    NSArray *lines;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:ftype];
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
   	
    while(tmp = (NSString*)[nse nextObject]) {
		NSString *portnumber = nil;
		NSString *protocol = nil;
        NSScanner *scanner = [NSScanner scannerWithString:tmp];
        [scanner scanUpToString:@"\t" intoString:&portnumber];
		[scanner scanUpToString:@"\n" intoString:&protocol];
		table[[portnumber intValue]] = [[NSString stringWithFormat:@"%@", protocol] retain];
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
		else if (proto < 143){
			return protolookup[proto];
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
	for (int i =0; i < 143; i++){
		if (protolookup[i] != NULL)
			[protolookup[i] release];	
	}
	[super dealloc];
	
}
@end
