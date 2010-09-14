//
//  NodeTuple.m
//  ContentionApp
//
//  Created by Tom Lodge on 29/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NodeTuple.h"



@implementation NodeTuple

@synthesize identifier;
@synthesize name;
@synthesize value;
@synthesize image;
@synthesize sport;
@synthesize dport;

-(id) initWithValues:(NSString *)i name:(NSString *)n value:(int)v{
	if (self = [super init]) {
		[self setIdentifier:i];	
		[self setName:n];
		[self setValue:v];
	}
	return self;
}

-(id) initWithValues:(NSString *)i name:(NSString *)n image:(NSString *) img value:(int)v{
	
	if (self = [super init]) {
		[self setDport: 0];
		[self setSport: 0];
        [self setIdentifier:i];	
		[self setName:n];
		[self setImage:img];
		[self setValue:v];
		
    }
    return self;	
	
}

-(id) initWithValues:(NSString *)i name:(NSString *)n image:(NSString *) img value:(int)v sport:(int)sp dport:(int) dp{
	
	if (self = [super init]) {
		[self setDport: dp];
		[self setSport: sp];
        [self setIdentifier:i];	
		[self setName:n];
		[self setImage:img];
		[self setValue:v];
		
    }
	
    return self;	
	
}
-(NSComparisonResult) sortByValue:(NodeTuple *) node{
	if (value < node.value)
		return NSOrderedDescending;
	else if (value > node.value)
		return NSOrderedAscending;
	return NSOrderedSame;
}

-(void) print{
	
	NSLog(@"name:%@ id:%@ image:%@ value:%d sport:%d dport:%d", name, identifier, image, value, sport, dport); 
}

-(void) dealloc{
	[identifier release];
	[name release];
	[image release];
	[super dealloc];
}
@end
