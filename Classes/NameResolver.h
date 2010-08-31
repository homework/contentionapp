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
+(NSString *)	lookup:(NSString *) ip_src destination:(NSString *) ip_dst;
+(NSString *)	getidentifier:(NSString *) ip_src destination:(NSString *) ip_dst;
+(NSString *)   lookup:(NSString *) ip_addr;
+(BOOL) isInternal:(NSString *) ipaddr;
+(void) update:(NSString *)oldname newname:(NSString*) newname;
+(void) printmactable;
@end
