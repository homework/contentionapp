//
//  LeaseRecord.m
//  ContentionApp
//
//  Created by Tom Lodge on 18/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LeaseRecord.h"


@implementation LeaseRecord
@synthesize macaddr;
@synthesize name;

-(id) initWithValues:(NSString *) m name:(NSString*) n{
	if (self = [super init]){
		[self setMacaddr:m];
		[self setName:n];
	}
	return self;
}


@end
