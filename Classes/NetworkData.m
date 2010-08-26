//
//  NetworkData.m
//  ContentionApp
//
//  Created by Tom Lodge on 13/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkData.h"

@interface NetworkData()
+ (void)updateApplicationData:(FlowObject *) fobj;
+ (void)updateNodeData:(FlowObject *) fobj;
+ (void)pollComplete: (NSNotification *) n;
+ (void)newPollToStart: (NSNotification *) n;
+ (void)newFlow: (NSNotification *) f;

@end

@implementation NetworkData


static int POLLNUMBER;


/*
 * Two collections: nodedata		Dictionary<deviceName, Dictionary<app, window>>
 * and				applicationdata Dictionary<appName, Dictionary<device, window>>
 */


static BOOL init = FALSE;
static NetworkTable *devicetable;
static NetworkTable *apptable;

+(void) initialize{
	if (!init){
		POLLNUMBER		= 0;
		
		devicetable = [[[NetworkTable alloc] init] retain];
		apptable = [[[NetworkTable alloc] init] retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFlow:) name:@"newFlowDataReceived" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPollToStart:) name:@"newPoll" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollComplete:) name:@"pollComplete" object:nil];
		init = TRUE;
	}
}


+(NSMutableArray *) getLatestApplicationData{	
	return [apptable getAllData];
	
}

+(NSMutableArray *) getLatestNodeData{	
	return [devicetable getAllData];
}




+(NSMutableArray *) getLatestApplicationDataForNode:(NSString *)node{
	
	return [devicetable getLatestDataForNode:node];
}

+(NSMutableArray *) getLatestNodeDataForApplication:(NSString *)app{
	return [apptable getLatestDataForNode:app];

}

+(float) getDeviceAppBandwidthProportion:(NSString *) node  application:(NSString *) a{
	return [devicetable getNodeBandwidthProportion:node subnode:a];
}




+(float) getApplicationBandwidthProportion:(NSString *) app{
	return [apptable getBandwidthProportion:app];
}

+(float) getDeviceBandwidthProportion:(NSString *) node{
	return [devicetable getBandwidthProportion:node];
}
		


+(void) pollComplete: (NSNotification *) n{
	POLLNUMBER += 1;
	[apptable setPOLLNUMBER:POLLNUMBER];
	[devicetable setPOLLNUMBER:POLLNUMBER];
	[apptable removeZeroByteData];
	[devicetable removeZeroByteData];
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
	NSString *device  = [NameResolver lookup:[fobj ip_src] destination:[fobj ip_dst]]; 
	
	[apptable updateData:application subnode:device bytes:[fobj bytes]];
}


+(void) updateNodeData:(FlowObject *) fobj{
	
	NSString *application = [FlowAnalyser guessApplication:[fobj sport] dport:[fobj dport] protocol:[fobj proto]];
	NSString *device  = [NameResolver lookup:[fobj ip_src] destination:[fobj ip_dst]]; 
	
	[devicetable updateData:device subnode:application bytes:[fobj bytes]];
	
}




+(void) dealloc{
	[devicetable release];
	[apptable release];
	[super dealloc];
}
@end
