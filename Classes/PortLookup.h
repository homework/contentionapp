//
//  PortLookup.h
//  ContentionApp
//
//  Created by Tom Lodge on 03/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PortLookup : NSObject {
	
	
}

+(NSString *)lookup:(int) port protocol:(int) proto;
+(NSString *) getApplicationImage:(NSString *) program;
+ (void)initPorts;
/*
+(NSString*) lookup:(int)port proto:(int)proto;
+(void) loadPortNumbers:(NSString *) name array:(NSString *[]) array;*/

@end
