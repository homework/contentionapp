//
//  NetworkData.h
//  ContentionApp
//
//  Created by Tom Lodge on 13/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowObject.h"
#import "NetworkTable.h"

#import "NodeTuple.h"
#import "Window.h"
#import "FlowRecord.h"
#import "FlowAnalyser.h"
#import "NameResolver.h"

@interface NetworkData : NSObject {

}

+(void)	initialize;
+(NSMutableArray *)getLatestApplicationData;
+(NSMutableArray *)getLatestNodeData;


+(float) getDeviceBandwidthProportion:(NSString *) node;
+(float) getDeviceAppBandwidthProportion:(NSString *) node  application:(NSString *) a;

+(float) getApplicationBandwidthProportion:(NSString *) app;
+(float) getAppDeviceBandwidthProportion:(NSString *) application  device:(NSString *) n;
@end
