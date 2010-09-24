//
//  ImageList.m
//  ContentionApp
//
//  Created by Tom Lodge on 24/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageList.h"


@implementation ImageList

static NSArray * _appthumbs;
static NSArray * _devicethumbs;
BOOL init = FALSE;

+(void) initimages{
	
	if (init)
		return;
	
	init = TRUE;
	
	_appthumbs = [[NSArray arrayWithObjects: @"web.png",
					  @"websecure.png",
					  @"music.png",
					  @"skype.png", 
					  @"telnet.png", 
					  @"chat.png",
					  @"windowsmedia.png", 
					  @"iplayer.png",
					  @"media.png", 
					  @"hwdb.png",
					  @"internet.png",
					  @"ftp.png",
					  @"wireless.png",
					  @"network.png",
					  @"email.png",
					  @"unknown.png",
					  nil] retain];
	
	_devicethumbs = [[NSArray arrayWithObjects: @"mac.png", 
				@"phone.png", 
				@"router.png",
				@"laptop.png", 
				@"iphone.png", 
				@"sound.png",
				@"blackberry.png",
				@"game.png",
				@"wii.png",
				@"ipad.png",
				@"printer.png",
				@"printserver.png",
				@"psp.png",
				@"macmini.png",
				@"unknown.png",
				nil] retain];
	
}

+(NSArray*) getList:(NSString *) type{

	if (!init)
		[self initimages];
	
	if ([type isEqualToString:@"devices"])
		return _devicethumbs;
	else if ([type isEqualToString:@"applications"])
		return _appthumbs;
	
	return NULL;
}

+(void) dealloc{
	[_devicethumbs release];
	[_appthumbs release];
	[super dealloc];
}
	
@end
