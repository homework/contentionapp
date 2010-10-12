//
//  FlowAnalyser.m
//  ContentionApp
//
//  Created by Tom Lodge on 12/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlowAnalyser.h"

@interface FlowAnalyser (PrivateMethods)
+(NSString*) getKey:(int) sport dport:(int)dp protocol:(int) proto;
@end

@implementation FlowAnalyser

+(void) addFlow:(unsigned short)sport dport:(unsigned short)dp protocol:(int)proto packets:(int)p bytes:(int)b pollcount:(int)pc{
	/*
	 * Entry point for packet analysis...
	 */
}

+(NSString*) getKey:(int) sport dport:(int)dp protocol:(int) proto{
	int minport = MIN(sport,dp);
	int maxport = MAX(sport,dp);
	return [NSString stringWithFormat:@"%d/%d/%d", maxport, minport, proto];
}

+(NSString*) guessApplication:(unsigned short)sport dport:(unsigned short)dp protocol:(int) proto{
	
	//filter out 0/0  - should we???
	if (dp <= 0 && sport <=0)
		return NULL;
	
	NSString *first    = [PortLookup lookup:MIN(sport,dp) protocol:proto];
	NSString *second	= [PortLookup lookup:MAX(sport, dp) protocol:proto];
	NSString *application;
	
	if (first == NULL && second == NULL){
		application = NULL;
	}
	if (first == NULL){
		if (second != NULL)
			application = second;
	}else if (second == NULL){
		if (first != NULL)
			application = first;		
	}else {
		if ([first isEqualToString:second]){
			application = first;
		}
		else
			application = [NSString stringWithFormat:@"%@ or %@",first, second];
	}
	if (application == NULL){
		application = [NSString stringWithFormat:@"%d/%d", MIN(sport,dp), MAX(sport,dp)];
	}
	else 
		application = [application stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return application;
}
-(void) dealloc{
	[super dealloc];
}
@end
