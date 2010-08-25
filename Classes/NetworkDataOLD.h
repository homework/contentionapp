//
//  NetworkData.h
//  ContentionApp
//
//  Created by Tom Lodge on 13/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowObject.h"
#import "NodeTuple.h"
#import "Window.h"
#import "FlowRecord.h"
#import "FlowAnalyser.h"
#import "NameResolver.h"

@interface NetworkDataOLD : NSObject {

}

+(void)	initialize;
+(NSMutableArray *)getLatestApplicationData;
+(NSMutableArray *)getLatestNodeData;
+(float) getDeviceBandwidthProportion:(NSString *) node;

@end
