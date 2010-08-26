//
//  ApplicationImageLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationImageLookup.h"


@implementation ApplicationImageLookup


+(NSString *) getImage:(NSString *) application{
	if (application == NULL){
		return @"unknown.png";
	}
	
	
	if ([application isEqualToString:@"hwdb"])
		return @"hwdb.png";
	
	if ([application isEqualToString:@"macromedia-fcs"])
		return @"iplayer.png";
	
	if ([application hasPrefix:@"https"])
		return @"websecure.png";
	
	if ([application hasPrefix:@"http"])
		return @"web.png";
	
	if ([application isEqualToString:@"ssh"])
		return @"telnet.png";
	
	if ([application hasPrefix:@"imap"])
		return @"email.png";
	
	return @"unknown.png";	
}


+(NSString *) getApplicationType:(NSString *) application{
	if (application == NULL){
		return @"unknown";
	}
	if ([application isEqualToString:@"macromedia-fcs"])
		return @"iplayer";
	
	if ([application hasPrefix:@"https"])
		return @"websecure";
	
	if ([application hasPrefix:@"http"])
		return @"web";
	
	if ([application isEqualToString:@"ssh"])
		return @"telnet";
	
	if ([application hasPrefix:@"imap"])
		return @"email";
	
	return application;	
}


@end
