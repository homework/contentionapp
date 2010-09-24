//
//  NetworkTable.m
//  ContentionApp
//
//  Created by Tom Lodge on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkTable.h"


@interface NetworkTable()



-(void) recalculateMaxBandwidth:(NSString*)node;

@end

@implementation NetworkTable

@synthesize POLLNUMBER;
@synthesize data;

int MAXBYTES = 1000;
int SHISTORY = 5;

-(id) init{
	if (self = [super init]) {
		NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:10];
		[self setPOLLNUMBER: 0];
		[self setData:tmp];
	}
	return self;
}


-(void) print:(NSString *) node{
	NSLog(@"windows for device %@", node);
	NSDictionary *dictionary = [data objectForKey:node];
	Window* w;
	for (id key in dictionary){
		w = [dictionary objectForKey:key];
		[w print:key];
	}
}

-(NSMutableArray *) getAllData{
	NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:10];// retain];
	
	for (id key1 in data) {
		NSDictionary *dictionary = [data objectForKey:key1];
		Window* w;
		for (id key2 in dictionary){
			w = [dictionary objectForKey:key2];
			NodeTuple* n = [results objectForKey:key1];
			if (n == NULL){
				n = [[NodeTuple alloc] initWithValues:key1 name:[NameResolver friendlynamefrommac:key1] value:[w totalBytes:POLLNUMBER]];
				[results setObject:n forKey:key1];
				[n release];
			}else{
				[n setValue:[n value] +  [w totalBytes:POLLNUMBER]];
			}
			
		}
	}
	return  [results allValues];
}

-(NSMutableArray *) getLatestDataForNode:(NSString *)node{
	NSMutableArray *array = [NSMutableArray array];// retain];
	NSDictionary *dictionary = [data objectForKey:node];
	Window * w;
	if (dictionary != NULL){
		for (id key in dictionary) {
			w = [dictionary objectForKey:key];
			NodeTuple* n = [[NodeTuple alloc] initWithValues:key name:[NameResolver friendlynamefrommac:key] value:[w totalBytes:POLLNUMBER]];// retain];
			[array addObject:n];
			[n release];
		}
	}
	return array;
}

/*
 * Bandwidth proportion for sub nodes
 */

-(float) getNodeBandwidthProportion:(NSString *) fornode  subnode:(NSString *) subnode{
	NSMutableDictionary *dictionary = [data objectForKey:fornode];
	if (dictionary != NULL){
		Window *w = [dictionary objectForKey:subnode];
		if (w != NULL){
			return (float) [w totalBytes:POLLNUMBER] / MAXBYTES;
		}
	}
	return 0;
}

/*
 * Bandwidth proportion for top nodes
 */

-(float) getBandwidthProportion:(NSString *) node{
	NSMutableDictionary *dictionary = [data objectForKey:node];
	int bandwidth= 0;
	
	for (id key in dictionary){
		Window *w = [dictionary objectForKey:key];
		bandwidth += [w totalBytes:POLLNUMBER];
	}	
	return (float)bandwidth / MAXBYTES;
}


-(void) updateData: (NSString*) topnode subnode:(NSString*) subnode bytes:(int) bytes{
	NSMutableDictionary *dictionary = [data objectForKey:topnode];
	
	if (dictionary == NULL){
		dictionary = [NSMutableDictionary dictionaryWithCapacity:10];// retain];
		[data setObject:dictionary forKey:topnode];
		
	}
	
	Window *w = [dictionary objectForKey:subnode];
	
	if (w == NULL){
		w = [[Window alloc]initWithSize:SHISTORY pollcount:POLLNUMBER];
		[dictionary setObject:w forKey:subnode];
		[w release];
	}
	
	[w addBytes:bytes pollcount:POLLNUMBER];
	
	[self recalculateMaxBandwidth: topnode];
	
}


-(void) recalculateMaxBandwidth:(NSString*)node{
	NSMutableDictionary *dictionary = [data objectForKey:node];
	int bandwidth = 0;
	
	for (id key in dictionary){
		Window *w = [dictionary objectForKey:key];
		bandwidth += [w totalBytes:POLLNUMBER];
	}
	MAXBYTES = MAX(bandwidth, MAXBYTES);
}

-(void) removeZeroByteData{
	
	
	NSMutableDictionary *todelete = [NSMutableDictionary dictionaryWithCapacity:10];
	NSMutableDictionary *dictionary;
	Window *w;
	int totalbytes;
	
	/*
	 *search out all entries that have windows of size 0;
	 */
	if (data != NULL){
		for (id key1 in data) {
			dictionary = [data objectForKey:key1];
			if (dictionary != NULL){
				
				for (id key2 in dictionary) {
					w = [dictionary objectForKey:key2];
					if (w != NULL){
						totalbytes =  [w totalBytes:POLLNUMBER];
						if ( totalbytes <= 0){
							[todelete setObject:key2 forKey:key1]; //mark for delete - can't modify within enumeration
						}
					}
				}
			}
		}
	}
	/*
	 NSMutableArray *keysToRemove = [NSMutableArray array];
	 for (id theKey in aDictionary) {
	 [keysToRemove addObject:theKey];
	 }
	 [aDictionary removeObjectsForKeys:keysToRemove];
	 */
	
	for (id key1 in todelete){
		NSString* key2 = [todelete objectForKey:key1];
		dictionary = [data objectForKey:key1];
		[dictionary removeObjectForKey:key2];
		if ([dictionary count] == 0){
			[data removeObjectForKey:key1];
		}
	}
}

-(void) dealloc{
	[data release];
	[super dealloc];
}
@end
