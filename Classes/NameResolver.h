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

@end
