//
//  LinkObject.h
//  ContentionApp
//
//  Created by Tom Lodge on 13/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "timestamp.h"
#include <stdint.h>

typedef struct link_data {
	uint64_t mac;
	double rss;
	unsigned long retries;
	unsigned long packets;
	unsigned long bytes;
	tstamp_t tstamp;
} LinkData;

@interface LinkObject : NSObject {

}



@end
