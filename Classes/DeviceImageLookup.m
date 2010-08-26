//
//  DeviceImageLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceImageLookup.h"


@implementation DeviceImageLookup

+(NSString *) getImage:(NSString *) program{
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(program like[cd] %@)
							  
	if (program == NULL){
		return @"unknown.png";
	}
	
	if ([program isEqualToString:@"hwdb"])
		return @"hwdb.png";
	
	if ([program isEqualToString:@"macromedia-fcs"])
		return @"iplayer.png";
	
	if ([program hasPrefix:@"https"])
		return @"websecure.png";
	
	if ([program hasPrefix:@"http"])
		return @"web.png";
	
	if ([program isEqualToString:@"ssh"])
		return @"telnet.png";
	
	if ([program hasPrefix:@"imap"])
		return @"email.png";
	
	return @"unknown.png";	
}

@end
