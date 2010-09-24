//
//  DeviceNameAlert.m
//  ContentionApp
//
//  Created by Tom Lodge on 27/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceNameAlert.h"


@implementation DeviceNameAlert

@synthesize deviceView;


-(void) dealloc{
	[deviceView release];
	[super dealloc];
}

@end
