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
+ (void)removeZeroByteData:(NSMutableDictionary *)data;
+(void) recalculateMaxNodeBandwidth:(NSString*)nodename application:(NSString*)app;
+ (void)recalculateMaxAppBandwidth:(NSString*)application node:(NSString*)node;
@end

@implementation NetworkData

static int SHISTORY = 5;
static int POLLNUMBER;


/*
 * Two collections: nodedata		Dictionary<deviceName, Dictionary<app, window>>
 * and				applicationdata Dictionary<appName, Dictionary<device, window>>
 */


static NSMutableDictionary *nodedata;
static NSMutableDictionary *applicationdata;
static BOOL init = FALSE;
static int MAXNODEBYTES = 1000;

+(void) initialize{
	if (!init){
		NSLog(@"initialising network data object");
		POLLNUMBER		= 0;
		applicationdata			= [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		nodedata				= [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFlow:) name:@"newFlowDataReceived" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPollToStart:) name:@"newPoll" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollComplete:) name:@"pollComplete" object:nil];
		init = TRUE;
		NSLog(@"finished initialising network data object");
	}
}


+(NSMutableArray *) getLatestApplicationData{	
	return [self getAllData:applicationdata];
}

+(NSMutableArray *) getLatestNodeData{	
	return [self getAllData:nodedata];
}

+(NSMutableArray *) getAllData:(NSMutableDictionary *) data{
	NSMutableDictionary *results = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	for (id key1 in data) {
		NSDictionary *dictionary = [data objectForKey:key1];
		Window* w;
		for (id key2 in dictionary){
			w = [dictionary objectForKey:key2];
			NodeTuple* n = [results objectForKey:key1];
			if (n == NULL){
				n = [[[NodeTuple alloc] initWithValues:key1 name:key1 value:[w totalBytes:POLLNUMBER]] retain];
				[results setObject:n forKey:key1];
			}else{
				[n setValue:[n value] +  [w totalBytes:POLLNUMBER]];
			}
		}
	}
	/*
	NSLog(@"returning...");
	for(NodeTuple * n in [results allValues]){
		NSLog(@"%@ %d", [n name], [n value]);
	}*/
	return  [results allValues];
}

+(NSMutableArray *) getLatestApplicationDataForNode:(NSString *)node{
	NSMutableArray *array = [[NSMutableArray array] retain];
	NSDictionary *dictionary = [nodedata objectForKey:node];
	Window * w;
	if (dictionary != NULL){
		for (id key in dictionary) {
			w = [dictionary objectForKey:key];
			NodeTuple* n = [[[NodeTuple alloc] initWithValues:key name:key value:[w totalBytes:POLLNUMBER]] retain];
			[array addObject:n];
		}
	}
	return array;
}

+(NSMutableArray *) getLatestNodeDataForApplication:(NSString *)app{
	NSMutableArray *array = [[NSMutableArray array] autorelease];
	NSDictionary *dictionary = [nodedata objectForKey:app];
	Window * w;
	if (dictionary != NULL){
		for (id key in nodedata) {
			w = [dictionary objectForKey:key];
			NodeTuple* n = [[[NodeTuple alloc] initWithValues:key name:key value:[w totalBytes:POLLNUMBER]] retain];
			[array addObject:n];
		}
	}
	return array;
}

+(float) getDeviceBandwidthProportion:(NSString *) node{
	return 0.5;
	/*Window*	   w = [nodebytehistory objectForKey:node];
	 int bytes	= [w totalBytes:POLLNUMBER]; 
	 NSLog(@"getting dev bandwidth proportion for device %@, bytes = %d and MAXNODEBYTES = %d and bandwitdh = %f",
	 node, bytes, MAXNODEBYTES, (float) bytes/MAXNODEBYTES);
	 
	 return (float) bytes / MAXNODEBYTES;*/
}

+(void) pollComplete: (NSNotification *) n{
	POLLNUMBER += 1;
	[self removeZeroByteData:applicationdata];
	[self removeZeroByteData:nodedata];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"newFlowData" object:nil];
}




+(void) newPollToStart: (NSNotification *) n{
}

+(void) newFlow: (NSNotification *) f{
	FlowObject  *fobj = (FlowObject *) [f object];
	[FlowAnalyser addFlow:[fobj sport] dport:[fobj dport] protocol:[fobj proto] packets:[fobj packets] bytes:[fobj bytes] pollcount:POLLNUMBER];
	[self updateApplicationData:fobj];
	[self updateNodeData:fobj];
}



+(void) updateApplicationData:(FlowObject *) fobj{
	NSString *application = [FlowAnalyser guessApplication:[fobj sport] dport:[fobj dport] protocol:[fobj proto]];
	NSString *nodename = [NameResolver lookup:[fobj ip_src] destination:[fobj ip_dst]]; 
	NSMutableDictionary *devicetowindow = [applicationdata objectForKey:application];
	
	if (devicetowindow == NULL){
		devicetowindow = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		[applicationdata setObject:devicetowindow forKey:application];
	}
	
	Window *w = [devicetowindow objectForKey:nodename];
	
	if (w == NULL){
		w = [[[Window alloc]initWithSize:SHISTORY pollcount:POLLNUMBER] retain];
		[devicetowindow setObject:w forKey:nodename];
	}
	
	[w addBytes:[fobj bytes] pollcount:POLLNUMBER];	
	
}


+(void) updateNodeData:(FlowObject *) fobj{
	NSString *application = [FlowAnalyser guessApplication:[fobj sport] dport:[fobj dport] protocol:[fobj proto]];
	NSString *nodename = [NameResolver lookup:[fobj ip_src] destination:[fobj ip_dst]]; 
	NSMutableDictionary *applicationtowindow = [nodedata objectForKey:nodename];
	
	if (applicationtowindow == NULL){
		applicationtowindow = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		[nodedata setObject:applicationtowindow forKey:nodename];
	}
	
	Window *w = [applicationtowindow objectForKey:application];
	
	if (w == NULL){
		w = [[[Window alloc]initWithSize:SHISTORY pollcount:POLLNUMBER] retain];
		[applicationtowindow setObject:w forKey:application];
	}	
	
									
	[w addBytes:[fobj bytes] pollcount:POLLNUMBER];	
	
	//[w print:nodename];
	
	[self recalculateMaxNodeBandwidth: nodename application:application];
}

+(void) recalculateMaxNodeBandwidth:(NSString*)nodename application:(NSString*)app{
	//MAXNODEBYTES = MAX([w totalBytes:POLLNUMBER], MAXNODEBYTES);
	//NSLog(@"current bytes for %@ is %d and MAXNODEBYTES is %d so bandwitdh is %f", [n name], [w totalBytes:POLLNUMBER], MAXNODEBYTES, (float)[w totalBytes:POLLNUMBER]/MAXNODEBYTES);
}

+(void) recalculateMaxAppBandwidth:(NSString*)appname node:(NSString*)nodename{
	//MAXNODEBYTES = MAX([w totalBytes:POLLNUMBER], MAXNODEBYTES);
	//NSLog(@"current bytes for %@ is %d and MAXNODEBYTES is %d so bandwitdh is %f", [n name], [w totalBytes:POLLNUMBER], MAXNODEBYTES, (float)[w totalBytes:POLLNUMBER]/MAXNODEBYTES);
}


+(void) removeZeroByteData:(NSMutableDictionary *)data{
	
	
	NSMutableDictionary *todelete = [NSMutableDictionary dictionaryWithCapacity:10];
	
	//NSEnumerator *enumerator = [data objectEnumerator];
	NSMutableDictionary *dictionary;
	Window *w;
	int totalbytes;
	
	NSLog(@"deleting zero byte entries..");
	/*
	 *search out all entries that have windows of size 0;
	 */
	if (data != NULL){
		for (id key1 in data) {
			dictionary = [data objectForKey:key1];
			if (dictionary != NULL){
				
				for (id key2 in dictionary) {
					w = [dictionary objectForKey:key2];
					if (w != NULL){
						totalbytes =  [w totalBytes:POLLNUMBER];
						if ( totalbytes <= 0){
							NSLog(@"adding %@ %@ to delete!", key1, key2);
							[todelete setObject:key2 forKey:key1]; //mark for delete - can't modify within enumeration
						}
					}
				}
			}
		}
	}
	/*
	NSMutableArray *keysToRemove = [NSMutableArray array];
	for (id theKey in aDictionary) {
		[keysToRemove addObject:theKey];
	}
	[aDictionary removeObjectsForKeys:keysToRemove];
	*/
	
	for (id key1 in todelete){
		NSString* key2 = [todelete objectForKey:key1];
		dictionary = [data objectForKey:key1];
		[dictionary removeObjectForKey:key2];
		if ([dictionary count] == 0){
			[data removeObjectForKey:key1];
		}
	}
}


+(void) dealloc{
	[applicationdata release];
	[nodedata release];
	[super dealloc];
}
@end
