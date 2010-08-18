//
//  LeaseObject.m
//  ContentionApp
//
//  Created by Tom Lodge on 16/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LeaseObject.h"


@implementation LeaseObject
@synthesize action;
@synthesize ipaddr;
@synthesize macaddr;
@synthesize name;

-(id) initWithLease: (DhcpData *) d{
	if (self = [super init])
	{
		action = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", index2action(d->action)]];
		ipaddr = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", inet_ntoa(d->ip_addr)]];
		macaddr= [[NSString alloc] initWithString: [NSString stringWithFormat:@"%012llx", d->mac_addr]];
		name   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", d->hostname]];
		tstamp = d->tstamp;
	}
	return self;
}

unsigned int action2index(char *action) {
	if (strcmp(action, "add") == 0)
		return 0;
	else
		if (strcmp(action, "del") == 0)
			return 1;
		else
			if (strcmp(action, "old") == 0)
				return 2;
			else
				return 3;
}

char *index2action(unsigned int index) {
	if (index == 0)
		return "add";
	else
		if (index == 1)
			return "del";
		else
			if (index == 2)
				return "old";
			else
				return "unknown";
}

-(void) print{
	NSLog(@"%@ %@ %@ %@", action, ipaddr,macaddr,name);
}

@end
