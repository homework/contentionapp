//
//  NetworkTable.h
//  ContentionApp
//
//  Created by Tom Lodge on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Window.h"
#import "NodeTuple.h"

@interface NetworkTable : NSObject {
	NSMutableDictionary *data;
	int POLLNUMBER;
}

@property(nonatomic, retain) NSMutableDictionary* data;
@property(nonatomic, assign) int POLLNUMBER;

-(id) init;
-(float) getNodeBandwidthProportion:(NSString *) fornode  subnode:(NSString *) subnode;
-(float) getBandwidthProportion:(NSString *) node;
-(NSMutableArray *) getLatestDataForNode:(NSString *)node;
-(float) getNodeBandwidthProportion:(NSString *) fornode  subnode:(NSString *) subnode;
-(float) getBandwidthProportion:(NSString *) node;
-(void) updateData: (NSString*) topnode subnode:(NSString*) subnode bytes:(int) bytes;
-(void) removeZeroByteData;
-(NSMutableArray *) getAllData;

@end
