//
//  NetworkData.m
//  ContentionApp
//
//  Created by Tom Lodge on 13/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkData.h"

@interface NetworkData()

+ (void)pollComplete: (NSNotification *) n;
+ (void)newPollToStart: (NSNotification *) n;
+ (void)newFlow: (NSNotification *) f;
+ (void)updateApplicationData:(FlowObject *) fobj;
+ (void)updateNodeData:(FlowObject *) fobj;
+ (void)removeZeroByteData:(NSMutableDictionary *)data history: (NSMutableDictionary *) history;
+ (void)generateTestData;

@end

@implementation NetworkData

const  int SLIDINGHISTORY = 5;
static int POLLNUMBER;
static NSMutableDictionary *nodedata;
static NSMutableDictionary *applicationdata;
static NSMutableDictionary *applicationbytehistory;
static NSMutableDictionary *nodebytehistory;

+(void) initialize{
	
	POLLNUMBER		= 0;
	applicationdata			= [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	applicationbytehistory	= [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	nodedata				= [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	nodebytehistory			= [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFlow:) name:@"newFlowDataReceived" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPollToStart:) name:@"newPoll" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollComplete:) name:@"pollComplete" object:nil];
}

+(NSMutableArray *) getLatestApplicationData{
	return (NSMutableArray*)[applicationdata allValues];
}

+(NSMutableArray *) getLatestNodeData{
	return (NSMutableArray*)[nodedata allValues];
}


+(void) pollComplete: (NSNotification *) n{
	
	POLLNUMBER += 1;
	[self removeZeroByteData:applicationdata history: applicationbytehistory];
	[self removeZeroByteData:nodedata history: nodebytehistory];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newFlowData" object:nil];
	//[self printTable];
	//[self.appView update:self.sorteddata];
}




+(void) newPollToStart: (NSNotification *) n{
}

+(void) newFlow: (NSNotification *) f{
	FlowObject  *fobj = (FlowObject *) [f object];
	//[fobj print];
	
    [FlowAnalyser addFlow:[fobj sport] dport:[fobj dport] protocol:[fobj proto] packets:[fobj packets] bytes:[fobj bytes] pollcount:POLLNUMBER];

	[self updateApplicationData:fobj];
	[self updateNodeData:fobj];
}

+(void) updateApplicationData:(FlowObject *) fobj{
	NSString *application = [FlowAnalyser guessApplication:[fobj sport] dport:[fobj dport] protocol:[fobj proto]];
	
	NodeTuple* n = [applicationdata objectForKey:application];
	Window*	   w = [applicationbytehistory objectForKey:application];
	
	if (n == NULL){
		n = [[[NodeTuple alloc] initWithValues:application name:application image: nil value:[fobj bytes]] autorelease];
		[n setDport:[fobj dport]];
		[n setSport:[fobj sport]];
		[applicationdata setObject:n forKey:application];
	}
	
	if (w == NULL){
		w = [[[Window alloc]initWithSize:SLIDINGHISTORY] autorelease];
		[w addBytes:[fobj bytes] pollcount:POLLNUMBER];
		[applicationbytehistory setObject:w forKey:application];
	}else{
		w = [applicationbytehistory objectForKey:application];
		[w addBytes:[fobj bytes] pollcount:POLLNUMBER];
	}		
}

+(void) updateNodeData:(FlowObject *) fobj{
	
	NSString *nodename = [NameResolver lookup:[fobj ip_src] destination:[fobj ip_dst]]; 
	
	NodeTuple* n = [nodedata objectForKey:nodename];
	Window*	   w = [nodebytehistory objectForKey:nodename];
	
	if (n == NULL){
		n = [[[NodeTuple alloc] initWithValues:nodename name:nodename image: nil value:[fobj bytes]] autorelease];
		[nodedata setObject:n forKey:nodename];
	}
	
	if (w == NULL){
		w = [[[Window alloc]initWithSize:SLIDINGHISTORY] autorelease];
		[w addBytes:[fobj bytes] pollcount:POLLNUMBER];
		[nodebytehistory setObject:w forKey:nodename];
	}else{
		w = [nodebytehistory objectForKey:nodename];
		[w addBytes:[fobj bytes] pollcount:POLLNUMBER];
	}		
}

+(void) generateTestData{
	
	if ( (POLLNUMBER % 4) == 0){
		
		applicationdata = [NSMutableArray arrayWithObjects:
						 [[[NodeTuple alloc] initWithValues:@"squid-http" name:@"squid-http" image:@"unknown.png" value:6013 sport:3128 dport:61667]  retain],
						 [[[NodeTuple alloc] initWithValues:@"mdns" name:@"mdns" image:@"unknown.png" value:260 sport:5353 dport:5353]  retain],
						 [[[NodeTuple alloc] initWithValues:@"domain" name:@"domain" image:@"unknown.png" value:164 sport:58001 dport:53]  retain],
						 [[[NodeTuple alloc] initWithValues:@"hwdb" name:@"hwdb" image:@"unknown.png" value:113 sport:49312 dport:987]  retain],
						 nil];
		
		
	}else if ( (POLLNUMBER % 4) == 1){
		applicationdata = [NSMutableArray arrayWithObjects:
						 [[[NodeTuple alloc] initWithValues:@"squid-http" name:@"squid-http" image:@"unknown.png" value:6013 sport:3128 dport:61667]  retain],
						 [[[NodeTuple alloc] initWithValues:@"hwdb" name:@"hwdb" image:@"unknown.png" value:1276 sport:49312 dport:987]  retain],
						 [[[NodeTuple alloc] initWithValues:@"mdns" name:@"mdns" image:@"unknown.png" value:260 sport:5353 dport:5353]  retain],
						 [[[NodeTuple alloc] initWithValues:@"domain" name:@"domain" image:@"unknown.png" value:164 sport:58001 dport:53]  retain],
						 nil];
		
	}else if ( (POLLNUMBER % 4) == 2){
		applicationdata = [NSMutableArray arrayWithObjects:
						 [[[NodeTuple alloc] initWithValues:@"squid-http" name:@"squid-http" image:@"unknown.png" value:6013 sport:3128 dport:61667]  retain],
						 [[[NodeTuple alloc] initWithValues:@"web" name:@"http-alt" image:@"web.png" value:3509 sport:64054 dport:8080]  retain],
						 [[[NodeTuple alloc] initWithValues:@"hwdb" name:@"hwdb" image:@"unknown.png" value:1903 sport:49312 dport:987]  retain],
						 [[[NodeTuple alloc] initWithValues:@"mdns" name:@"mdns" image:@"unknown.png" value:260 sport:5353 dport:5353]  retain],
						 [[[NodeTuple alloc] initWithValues:@"rockwell-csp2" name:@"rockwell-csp2" image:@"unknown.png" value:228 sport:49689 dport:2223]  retain],
						 [[[NodeTuple alloc] initWithValues:@"domain" name:@"domain" image:@"unknown.png" value:164 sport:58001 dport:53]  retain],
						 [[[NodeTuple alloc] initWithValues:@"websecure" name:@"https" image:@"websecure.png" value:134 sport:63899 dport:443]  retain],
						 nil];
		
	}else if ( (POLLNUMBER % 4) == 3){
		applicationdata = [NSMutableArray arrayWithObjects:
						 [[[NodeTuple alloc] initWithValues:@"squid-http" name:@"squid-http" image:@"unknown.png" value:6013 sport:3128 dport:61667]  retain],
						 [[[NodeTuple alloc] initWithValues:@"web" name:@"http-alt" image:@"web.png" value:3509 sport:64054 dport:8080]  retain],
						 [[[NodeTuple alloc] initWithValues:@"hwdb" name:@"hwdb" image:@"unknown.png" value:1903 sport:49312 dport:987]  retain],
						 [[[NodeTuple alloc] initWithValues:@"mdns" name:@"mdns" image:@"unknown.png" value:260 sport:5353 dport:5353]  retain],
						 [[[NodeTuple alloc] initWithValues:@"websecure" name:@"https" image:@"websecure.png" value:453 sport:63899 dport:443]  retain],
						 [[[NodeTuple alloc] initWithValues:@"rockwell-csp2" name:@"rockwell-csp2" image:@"unknown.png" value:228 sport:49689 dport:2223]  retain],
						 [[[NodeTuple alloc] initWithValues:@"domain" name:@"domain" image:@"unknown.png" value:164 sport:58001 dport:53]  retain],
						 nil];
	}
	
	/*NSEnumerator *enumerator = [self.testdata objectEnumerator];
	 NodeTuple* node;
	 int count = 0;
	 
	 while ( (node = [enumerator nextObject])) {
	 int rand = (arc4random() % 10000) *  (arc4random() % 2 ? 1 : -1);
	 node.value = MAX(1, (node.value + rand));		
	 }
	 */
	
	POLLNUMBER += 1;
	
}


+(void) removeZeroByteData:(NSMutableDictionary *)data history: (NSMutableDictionary *) history{
	
	NSEnumerator *enumerator = [data objectEnumerator];
	NodeTuple* node;
	
	NSMutableArray *todelete = [NSMutableArray arrayWithCapacity:SLIDINGHISTORY]; 
	
	while ( (node = [enumerator nextObject])) {
		Window *w = [history objectForKey:[node name]];
		if (w != NULL){
			int totalbytes =  [w totalBytes:POLLNUMBER];
			if ( totalbytes > 0){
				[node setValue:totalbytes];
			}else{
				[todelete addObject:[node name]];  //mark for delete!
			}
		}
	}
	
	enumerator = [todelete objectEnumerator];
	NSString* s;
	
	while ( (s = [enumerator nextObject])) {
		[data removeObjectForKey:s];
	}
}


+(void) dealloc{
	[applicationdata release];
	[applicationbytehistory release];
	[super dealloc];
}
@end
