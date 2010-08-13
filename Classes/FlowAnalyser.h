//
//  FlowAnalyser.h
//  ContentionApp
//
//  Created by Tom Lodge on 12/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PortLookup.h"
#import "LongTuple.h"

@interface FlowAnalyser : NSObject {
	
}


+(void)			initTables;
+(void)			addFlow:(unsigned short) sport dport:(unsigned short)dp protocol:(int) proto packets:(int) p bytes:(int) b pollcount:(int) pc;
+(NSString*)	guessApplication:(unsigned short) sport dport:(unsigned short)dp protocol:(int) proto;

@end
