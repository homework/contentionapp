//
//  DeviceNameObject.h
//  ContentionApp
//
//  Created by Tom Lodge on 30/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "timestamp.h"

typedef struct device_name_data {
	in_addr_t ip_addr;
    char name[256];
	tstamp_t tstamp;
} DeviceNameData;



@interface DeviceNameObject : NSObject {
    NSString *ipaddr;
    NSString *name;
    tstamp_t tstamp;
}

@property(nonatomic,assign) NSString *ipaddr;
@property(nonatomic,assign) NSString *name;

-(id) initWithDeviceNameData: (DeviceNameData *) dnd;

@end
