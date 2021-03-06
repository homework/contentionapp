//
//  NameResolver.h
//  ContentionApp
//
//  Created by Tom Lodge on 18/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeaseRecord.h"
#import "LeaseObject.h"
#import "DeviceNameObject.h"

#include <netinet/ip.h>	
@interface NameResolver : NSObject {

}

+(void)			initialize;
+(NSString *)   friendlynamefrommac:(NSString *) macaddr;
+(NSString *)	friendlynamefromip:(NSString *) ip_addr;
+(NSString *)	getidentifier:(NSString *) ip_addr;
+(BOOL) isInternal:(NSString *) ipaddr;
+(NSString *) getIP:(NSString*)identifier;

+(void) update:(NSString *)oldname newname:(NSString*) newname;
+(void) printmactable;
+(void) printiptable;
@end
