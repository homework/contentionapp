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
-(void) addBytes:(int) value pollcount:(int) pc;
-(int) totalBytes:(int) pollcount;
-(void) print:(NSString*)application;
-(void) merge:(Window *) w;

@end
