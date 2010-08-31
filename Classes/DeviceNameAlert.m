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

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
	}
	return self;
}

-(void) dealloc{
	[deviceView release];
	[super dealloc];
}

@end
