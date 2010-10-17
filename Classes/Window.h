//
//  Window.h
//  ContentionApp
//
//  Created by Tom Lodge on 11/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Window : NSObject {
	NSMutableArray* window;
	int lastpoll;
	int CAPACITY;
}

@property(nonatomic, retain) NSMutableArray* window;
@property(nonatomic, readonly) int lastpoll;

-(id) initWithSize:(int)size pollcount:(int) pc;
-(void) addBytes:(unsigned int) value pollcount:(int) pc;
-(unsigned int) totalBytes:(int) pollcount;
-(void) print:(NSString*)application pc:(int) pc;
-(unsigned int) lastBytes:(int) pc;
@end
