//
//  DeviceImageLookup.h
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface DeviceImageLookup : NSObject{
	
}

+(void)	initialize;
+(void) update:(NSString *) image forNode:(NSString *) app;
+(NSString *) getImage:(NSString *) program;
@end
