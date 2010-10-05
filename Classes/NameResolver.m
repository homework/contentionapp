//
//  NameResolver.m
//  ContentionApp
//
//  Created by Tom Lodge on 18/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NameResolver.h"

@interface NameResolver (PrivateMethods)
+(void) newLease:(NSNotification *) n;
+(void) writeMacTable;
+(unsigned int) intFromIP:(NSString *)ipaddr;
@end

int count;
NSMutableDictionary *iplookuptable;
NSMutableDictionary *maclookuptable;

//NSString* netmask  = @"192.168.9";
static BOOL init = FALSE;
static char result[16];
static unsigned int localnetaddr;
static unsigned int netmask;

@implementation NameResolver

char* IPAddressToString(unsigned int ip)
{
	sprintf(result, "%d.%d.%d.%d",
			(ip >> 24) & 0xFF,
			(ip >> 16) & 0xFF,
			(ip >>  8) & 0xFF,
			(ip      ) & 0xFF);
	return result;
}

unsigned int IPToInt(unsigned int c1, unsigned int c2, unsigned int c3, unsigned int c4){
	scanf("%d.%d.%d.%d",&c1,&c2,&c3,&c4);
	unsigned int ip = (unsigned int)c4+c3*256+c2*256*256+c1*256*256*256;
	return ip;
}

unsigned int getNetmask(unsigned int suffix){
	return ~(0xffffffff >> suffix);
}

+(void) initialize{
	if (init)
		return;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; 
	/*test netmask code*/
	NSString *CIDRaddr = [userDefaults stringForKey:@"SUBNET"];
	
	if (CIDRaddr == NULL)
		CIDRaddr = @"192.168.9.0/24";
	
	NSLog(@"netmask is %@", CIDRaddr);
	NSArray *split = [CIDRaddr componentsSeparatedByString: @"/"];
	localnetaddr = [self intFromIP:[split objectAtIndex:0]];
	unsigned int mask = [[split objectAtIndex:1] intValue];
	//localnetaddr = IPToInt(192, 168, 9, 0);
	netmask = getNetmask(mask);
	
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"mactable.txt"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:path]){
		maclookuptable = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] retain];
	}else{
		maclookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	}
	
	[fileManager release];
	
	iplookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLease:) name:@"newLeaseDataReceived" object:nil];
	init = TRUE;
	
}

+(unsigned int) intFromIP:(NSString *)ipaddr{
	NSArray *chunks = [ipaddr componentsSeparatedByString: @"."];
	
	unsigned int tmpip = IPToInt( [[chunks objectAtIndex:0] intValue],
								 [[chunks objectAtIndex:1] intValue],
								 [[chunks objectAtIndex:2] intValue],
								 [[chunks objectAtIndex:3] intValue]
								 );
	return tmpip;
}

+(BOOL) isInternal:(NSString *) ipaddr{
	
	unsigned int tmpip = [self intFromIP: ipaddr];
		
	return (netmask&localnetaddr) == (netmask&tmpip);
}

/*
 * This will attempt to return the unique identfier (i.e. mac address) for the
 * internal IP address (whether src or destination). If it is not found, NULL 
 * is returned.  Note it is possible that it won't be returned if no lease entry
 * exists for the IP address..
 */


+(NSString *) getidentifier:(NSString *)ip_addr{
	
	if (ip_addr == NULL)
		return NULL;
	
	if([ip_addr length] <= 9)
		return NULL;

	if (![self isInternal:ip_addr]){
		return NULL;
	}
	
	return [iplookuptable objectForKey:ip_addr];
}

+(NSString *) friendlynamefrommac:(NSString *) macaddr{
	
	NSString * resolvedname = NULL;
	
	resolvedname = NULL;
	
	if (macaddr != NULL){
		resolvedname = [maclookuptable objectForKey:macaddr];
	}
	
	return (resolvedname == NULL) ? macaddr:resolvedname;
}

+(NSString *) friendlynamefromip:(NSString *) ip_addr{
	
	if([ip_addr length] <= 9)
		return NULL;
	
	if (![self isInternal:ip_addr])
		return NULL;
	
	NSString* macaddr = [iplookuptable objectForKey:ip_addr];
	
	if (macaddr != NULL){
		return [maclookuptable objectForKey:macaddr];
	}
	
	return NULL;
}

+(void) update:(NSString *)macaddr newname:(NSString*) newname{
	[maclookuptable setObject:newname forKey:macaddr];
	[self writeMacTable];
}

+(void)printmactable{
	NSLog(@"MAC TABLE AS FOLLOWS");
	for (id key in maclookuptable){
		NSString *name = [maclookuptable objectForKey:key];
		NSLog(@"%@    %@", key, name);
	}
}

+(void)printiptable{
	NSLog(@"IP TABLE AS FOLLOWS");
	for (id key in iplookuptable){
		NSString *name = [iplookuptable objectForKey:key];
		NSLog(@"%@    %@", key, name);
	}
}

+(void) newLease:(NSNotification *) n{
	
	LeaseObject  *lobj = (LeaseObject *) [n object];
	
	[iplookuptable setObject:[lobj macaddr] forKey:[lobj ipaddr]];
	NSString* humanname = [maclookuptable objectForKey:[lobj macaddr]];
	
	if (humanname == NULL){
		humanname = [[lobj name] isEqualToString:@" "] ? [lobj ipaddr] : [lobj name]; 
		[maclookuptable setObject:humanname forKey:[lobj macaddr]];
		[self writeMacTable];
	}
}

+(void) writeMacTable{
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"mactable.txt"];
	[maclookuptable writeToFile:path atomically:YES];
}

-(void) dealloc{
	[maclookuptable release];
	[iplookuptable release];
	[super dealloc];
}


@end
