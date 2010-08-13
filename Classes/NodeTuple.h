//
//  NodeTuple.h
//  ContentionApp
//
//  Created by Tom Lodge on 29/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NodeTuple : NSObject {
	unsigned short sport;
	unsigned short dport;
	NSString *identifier;
	NSString *name;
	NSString *image;

	int value; 
}

@property(nonatomic,retain) NSString* identifier;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* image;
@property(nonatomic,assign) int value;
@property(nonatomic,assign) unsigned short sport;
@property(nonatomic,assign) unsigned short dport;

-(NSComparisonResult) sortByValue:(NodeTuple *) node;
-(id) initWithValues:(NSString*) i name:(NSString*) n image:(NSString*) img value:(int) v;
-(id) initWithValues:(NSString *)i name:(NSString *)n image:(NSString *) img value:(int)v sport:(int)sp dport:(int) dp;
-(void) print;
@end
