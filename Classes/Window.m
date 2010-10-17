//
//  Window.m
//  ContentionApp
//
//  Created by Tom Lodge on 11/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Window.h"
@interface Window (PrivateMethods)
-(void) emptyOldSlots:(int) pc;
@end

@implementation Window

@synthesize window;
@synthesize lastpoll;

-(id) initWithSize:(int)size pollcount:(int) pc{
	
	if (self = [super init]) {
		CAPACITY = size;
		lastpoll = pc;
		NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:CAPACITY];
		[self setWindow: tmp];
		[tmp release];
		 
		for (int i = 0; i < CAPACITY; i++){
			[window addObject: [NSNumber numberWithUnsignedInt:0]];	
		}
	}
	
	return self;	
}

-(void) addBytes:(unsigned int)value pollcount:(int)pc{
	
	if (pc != lastpoll)
		[window replaceObjectAtIndex:pc%CAPACITY withObject:[NSNumber numberWithUnsignedInt:value]];
	else{
		unsigned int bytes = [((NSNumber*)[window objectAtIndex:pc%CAPACITY]) unsignedIntValue];
		bytes += value;
		[window replaceObjectAtIndex:pc%CAPACITY withObject:[NSNumber numberWithUnsignedInt:bytes]];
	}
	/*
	 * Set slots to 0 for any missed polls
	 */
	[self emptyOldSlots:pc];
	lastpoll = pc;
}

-(void) print:(NSString*) application pc:(int)pc{
	NSEnumerator *enumerator = [window objectEnumerator];
    NSNumber* n;
	int count = 0;
	DLog(@"%@",application);
	while ( (n = [enumerator nextObject])) {
		NSLog(@"slot %d = %u %@",count, [n unsignedIntValue], (count == lastpoll%CAPACITY) ? @"*" : @"");
		count++;
	}
	DLog(@"LAST ADDED = %u", [self lastBytes:pc]);
}

-(unsigned int) lastBytes:(int) pc{
	if (pc != lastpoll){  //nothing retrieved in last poll
		return 0;
	}
	
	return [[window objectAtIndex:pc%CAPACITY] unsignedIntValue]; 
}

-(unsigned int) totalBytes:(int)pc{
	
	/*
	 * Set slots to 0 for any missed polls
	 */	
	[self emptyOldSlots:pc];
	
	if ((pc-lastpoll) > CAPACITY){
		return 0;
	}
	
	unsigned int total = 0;
	
	NSEnumerator *enumerator = [window objectEnumerator];
    NSNumber* n;
	
	while ( (n = [enumerator nextObject])) {
		total += [n unsignedIntValue];
	}
	return total;
}

-(void) emptyOldSlots:(int) pc{	
	if ((pc - lastpoll) > 1){
		for (int i = (lastpoll + 1) ; i < pc; i++){
			[window replaceObjectAtIndex:i%CAPACITY withObject:[NSNumber numberWithUnsignedInt:0]];
		}
	}	
}

-(void) dealloc{
	[window release];
	[super dealloc];
}
@end
