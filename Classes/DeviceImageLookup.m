//
//  DeviceImageLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceImageLookup.h"


@implementation DeviceImageLookup


static NSMutableDictionary *lookuptable;
static BOOL init = false;

+(void) initialize{
	if (!init){
		lookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		init = TRUE;
	}
}

+(NSString *) getImage:(NSString *) program{
	
	NSString *imagename;
	
	if ( (imagename = [lookuptable objectForKey:program]) == NULL){
		return [self getDefault:program];
	}
	
	return imagename;							  
}

+(NSString *) getDefault:(NSString *) program{
	return @"unknown.png";	
}

+(void) update:(NSString *) image forNode:(NSString *) app{
	[lookuptable setObject:image forKey:app];
}

@end
