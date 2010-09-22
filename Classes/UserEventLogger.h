//
//  UserEventLogger.h
//  ContentionApp
//
//  Created by Tom Lodge on 21/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPCSend.h"

@interface UserEventLogger : NSObject {

}

+(void) log: (NSString *)event subevent:(NSString *) subevent;
+(void) logimagechange:(NSString*)identifier newimage:(NSString*)image screen:(NSString*)screen;
+(void) lognamechange:(NSString*)identifier newname:(NSString*)name screen:(NSString*)screen;
+(void) logdrilldown:(NSString*)identifier position:(int)index screen:(NSString*)screen;

@end
