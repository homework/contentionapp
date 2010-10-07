//
//  UserEventLogger.m
//  ContentionApp
//
//  Created by Tom Lodge on 21/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserEventLogger.h"


@implementation UserEventLogger



+(void) log:(NSString *)type logdata:(NSString *)logdata{

	
	
	NSString* query = [NSString stringWithFormat:@"SQL:insert into UserEvents values (\"%@\", \"%@\", \"%@\")\n",
						@"ContentionApp", type, logdata];
	
	[NSThread detachNewThreadSelector:@selector(sendquery:) toTarget:self withObject:query];
}

+(void) updateLeases:(NSString*)macaddr newname:(NSString*)name{
	NSString* query = [NSString stringWithFormat:@"SQL:INSERT into Leases values (\"%@\", \"%@\", \"%@\", \"%@\")\n",
					   @"UPD", macaddr, @"192.168.9.10", name];
	
	[NSThread detachNewThreadSelector:@selector(sendquery:) toTarget:self withObject:query];
	
}

+(void) sendquery:(NSString *) query{
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	[RPCSend sendquery:query];
	[autoreleasepool release];
}

/*
 * Creates a userEvent entry of the form AppName, imageUpdate, Screen;NodeId;NewImage
 */
+(void) logimagechange:(NSString*)identifier newimage:(NSString*)image screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@;%@",screen, identifier,image];
	[self log:@"imageupdate" logdata:logdata];
}
					   
/*
 * Creates a userEvent entry of the form AppName, nameupdate, Screen;NodeId;NewName
 */

+(void) lognamechange:(NSString*)macaddr newname:(NSString*)name screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@;%@",screen, macaddr,name];
	[self log:@"nameupdate" logdata:logdata];
	/*
	 * Also want to update the leases table!
	 */
	
	[self updateLeases:macaddr newname:name];
	
}

/*
 * Creates a userEvent entry of the form AppName, drilldown, Screen;NodeId;Position
 */
					   
+(void) logdrilldown:(NSString*)identifier position:(int)index screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@;%d",screen, identifier,index];
	[self log:@"drilldown" logdata:logdata];
}


/*
 * Creates a userEvent entry of the form AppName, startup
 */


+(void) logstartup{
	NSString* logdata = [NSString stringWithFormat:@" "];
	[self log:@"startup" logdata:logdata];
}

/*
 * Creates a userEvent entry of the form AppName, startup
 */

+(void) logshutdown{
	NSString* logdata = [NSString stringWithFormat:@" "];
	[self log:@"shutdown" logdata:logdata];
}

+(void) logscreenchange:(NSString *) toScreen{
	NSString* logdata = [NSString stringWithFormat:@"%@", toScreen];
	[self log:@"screenswitch" logdata:logdata];
}



@end
