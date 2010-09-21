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
	
	NSString* query = [[NSString stringWithFormat:@"SQL:insert into UserEventLog values ('%@', '%@', '%@')\n",
						@"ContentionApp", type, logdata];
	
	[RPCSend sendquery:query];
}

/*
 * Creates a userEvent entry of the form AppName, LogType, Screen;NodeId;NewImage
 */
+(void) logimagechange:(NSString*)identifier newimage:(NSString*)image screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@;%@",screen, identifier,newimage];
	[self log:@"imageUpdate" logdata:logdata];
}
					   
/*
 * Creates a userEvent entry of the form AppName, LogType, Screen;NodeId;NewName
 */

+(void) lognamechange:(NSString*)identifier newname:(NSString*)image screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@;%@",screen, identifier,newimage];
	[self log:@"nameUpdate" logdata:logdata];
}

/*
 * Creates a userEvent entry of the form AppName, LogType, Screen;NodeId;Position
 */
					   
+(void) logdrilldown:(NSString*)identifier position:(int)index screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@;%d",screen, identifier,index];
	[self log:@"drilldown" logdata:logdata];
}

/*
 * Creates a userEvent entry of the form AppName, LogType, Screen;NodeId;
 */					   
+(void) logscreenpop:(NSString*) identifier screen:(NSString*)screen{
	NSString* logdata = [NSString stringWithFormat:@"%@;%@",screen, identifier];
	[self log:@"screenpop" logdata:logdata];

}




@end
