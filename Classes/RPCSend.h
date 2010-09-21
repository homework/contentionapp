//
//  RPCSend.h
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "config.h"
#include "srpc.h"

@interface RPCSend : NSObject {
	
}

+(BOOL) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned *) len;
+(BOOL) sendquery:(NSString *)q;

@end
