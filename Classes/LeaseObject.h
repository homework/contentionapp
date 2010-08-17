//
//  LeaseObject.h
//  ContentionApp
//
//  Created by Tom Lodge on 16/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "timestamp.h"

typedef struct dhcp_data {
	unsigned int action; // 0:add 1:del 2:old
	uint64_t mac_addr;
	in_addr_t ip_addr;
	char hostname[80];
	tstamp_t tstamp;
} DhcpData;

@interface LeaseObject : NSObject {

}

@end
