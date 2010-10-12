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

@interface NameResolver : NSObject {

}

+(void)			initialize;
+(NSString *)   friendlynamefrommac:(NSString *) macaddr;
+(NSString *)	friendlynamefromip:(NSString *) ip_addr;
+(NSString *)	lookupip:(NSString*) macaddr;
+(NSString *)	getidentifier:(NSString *) ip_addr;
+(BOOL) isInternal:(NSString *) ipaddr;
+(void) update:(NSString *)oldname newname:(NSString*) newname;
+(void) printmactable;
+(void) printiptable;
@end
