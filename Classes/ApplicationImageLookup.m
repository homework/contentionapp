//
//  ApplicationImageLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationImageLookup.h"


@implementation ApplicationImageLookup


+(NSString *) getApplicationImage:(NSString *) program{
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


+(NSString *) getApplicationType:(NSString *) program{
	if (program == NULL){
		return @"unknown";
	}
	if ([program isEqualToString:@"macromedia-fcs"])
		return @"iplayer";
	
	if ([program hasPrefix:@"https"])
		return @"websecure";
	
	if ([program hasPrefix:@"http"])
		return @"web";
	
	if ([program isEqualToString:@"ssh"])
		return @"telnet";
	
	if ([program hasPrefix:@"imap"])
		return @"email";
	
	return program;	
}


@end
