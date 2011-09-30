//
//  DeviceNameObject.m
//  ContentionApp
//
//  Created by Tom Lodge on 30/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceNameObject.h"


@implementation DeviceNameObject

@synthesize ipaddr;
@synthesize name;

-(id) initWithDeviceNameData: (DeviceNameData *) dnd{
    if (self = [super init])
	{

        ipaddr = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", inet_ntoa(dnd->ip_addr)]];
        name   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", dnd->name]];
    }
    return self;
}

@end
