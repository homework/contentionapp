//
//  FlowAnalyser.m
//  ContentionApp
//
//  Created by Tom Lodge on 12/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlowAnalyser.h"


@implementation FlowAnalyser

static NSMutableDictionary *meanvalues;


+(void) initTables{
	meanvalues = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
}

+(void) addFlow:(unsigned short)sport dport:(unsigned short)dp protocol:(int)proto packets:(int)p bytes:(int)b pollcount:(int)pc{
	
	
	NSString* key = [self getKey:sport dport:dp protocol:proto];	
	if (key != NULL){
		float meanpacket;
		LongTuple* t = [meanvalues objectForKey:key];
		if (t==NULL){
			t = [[LongTuple alloc] retain];
			t.first = p;
			t.second = b;
			[meanvalues setObject:t forKey:key];
		}else{
			t.first += p;
			t.second += b;
		}
		meanpacket = (float) t.second / t.first;
	}
	
}

+(NSString*) getKey:(int) sport dport:(int)dp protocol:(int) proto{
	int minport = MIN(sport,dp);
	int maxport = MAX(sport,dp);
	return [NSString stringWithFormat:@"%d/%d/%d", maxport, minport, proto];
}

+(NSString*) guessApplication:(unsigned short)sport dport:(unsigned short)dp protocol:(int) proto{
	
	NSString *first    = [PortLookup lookup:sport protocol:proto];
	NSString *second	= [PortLookup lookup:dp protocol:proto];
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
		int minport = MIN(sport,dp);
		int maxport = MAX(sport,dp);
		application = [NSString stringWithFormat:@"%d/%d", minport, maxport];
	}
	else 
		application = [application stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return application;
}
@end
