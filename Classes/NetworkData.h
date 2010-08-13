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

@interface NetworkData : NSObject {

}

+(void)	initialize;
+(NSMutableArray *)getLatest;

@end
