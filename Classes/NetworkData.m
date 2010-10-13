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

+(NSMutableArray *) getLatestDeviceDataForApplication:(NSString *)app{
	return [apptable getLatestDataForNode:app];
}

+(float) getDeviceAppBandwidthProportion:(NSString *) node  application:(NSString *) a{
	return [devicetable getNodeBandwidthProportion:node subnode:a];
}

+(float) getAppDeviceBandwidthProportion:(NSString *) application  device:(NSString *) n{
	return [apptable getNodeBandwidthProportion:application subnode:n];
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
	[devicetable print:@"001ff3bcb257"];
	
}

+(void) newFlow: (NSNotification *) f{
	FlowObject  *fobj = (FlowObject *) [f object];
	[FlowAnalyser addFlow:[fobj sport] dport:[fobj dport] protocol:[fobj proto] packets:[fobj packets] bytes:[fobj bytes] pollcount:POLLNUMBER];
	[self updateApplicationData:fobj];
	[self updateNodeData:fobj];
	
}


+(void) updateApplicationData:(FlowObject *) fobj{
	NSString *application = [FlowAnalyser guessApplication:[fobj sport] dport:[fobj dport] protocol:[fobj proto]];
	
	//FlowAnalyser can filter out flows we don't want to show.
	if (application == NULL)
		return;
	
	NSString *deviceid  = [NameResolver getidentifier:[fobj ip_src]]; 
	
	if (deviceid != NULL){
		[apptable updateData:application subnode:deviceid bytes:[fobj bytes]];
	}
	
	deviceid = [NameResolver getidentifier:[fobj ip_dst]];
	
	if (deviceid != NULL){
		[apptable updateData:application subnode:deviceid bytes:[fobj bytes]];
	}
}


+(void) updateNodeData:(FlowObject *) fobj{
	
	NSString *application = [FlowAnalyser guessApplication:[fobj sport] dport:[fobj dport] protocol:[fobj proto]];
	
	
	if (application == NULL){
		return;
	}
	
	NSString *deviceid  = [NameResolver getidentifier:[fobj ip_src]];
	
	if (deviceid != NULL){
		[devicetable updateData:deviceid subnode:application bytes:[fobj bytes]];
	}
	
	
	deviceid  = [NameResolver getidentifier:[fobj ip_dst]];
	
	if (deviceid != NULL){
		[devicetable updateData:deviceid subnode:application bytes:[fobj bytes]];
	}
		
}


+(void) dealloc{
	[devicetable release];
	[apptable release];
	[super dealloc];
}
@end
