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
+(void) createMacLookupTable;
+(void) createIPLookupTable;
+(void) addObservers;
+(void) createLocalNetmask;
+(BOOL) isIP:(NSString *) string;
@end

NSMutableDictionary *iplookuptable;
NSMutableDictionary *maclookuptable;

static BOOL init = FALSE;
static char result[16];
static unsigned int localnetaddr;
static unsigned int netmask;

static NSString* DEFAULTCIDR = @"10.2.0.0/24";


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
	[self createLocalNetmask];
	[self createMacLookupTable];
	[self createIPLookupTable];
	[self addObservers];
	init = TRUE;
}

+(void) createLocalNetmask{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; 
	
	NSString *CIDRaddr = [userDefaults stringForKey:@"SUBNET"];
	
	if (CIDRaddr == NULL){
		DLog(@"defaulting to addr %@", DEFAULTCIDR);
		CIDRaddr = DEFAULTCIDR;
	}
	
	NSArray *split = [CIDRaddr componentsSeparatedByString: @"/"];
	localnetaddr = [self intFromIP:[split objectAtIndex:0]];
	unsigned int mask = [[split objectAtIndex:1] intValue];
	netmask = getNetmask(mask);
}


+(void) createMacLookupTable{
	/*
	 * needed for remembering application names!
	 */
  
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"mactable.txt"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:path]){
		maclookuptable = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] retain];
	}else{
		maclookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	}
	[fileManager release];	
	
	
	//maclookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
}

+(void) addObservers{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLease:) name:@"newLeaseDataReceived" object:nil];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDeviceData:) name:@"newDeviceDataReceived" object:nil];	
}

+(void) createIPLookupTable{
	iplookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
}

+(unsigned int) intFromIP:(NSString *)ipaddr{
	
	NSArray *chunks = [ipaddr componentsSeparatedByString: @"."];
	
	if ([chunks count] >=4){
		unsigned int tmpip = IPToInt( [[chunks objectAtIndex:0] intValue],
								 [[chunks objectAtIndex:1] intValue],
								 [[chunks objectAtIndex:2] intValue],
								 [[chunks objectAtIndex:3] intValue]
								 );
		return tmpip;
	}
	
	return 0;
}

+(BOOL) isInternal:(NSString *) ipaddr{
	unsigned int tmpip = [self intFromIP: ipaddr];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; 

	NSString *CIDRaddr = [userDefaults stringForKey:@"SUBNET"];
    
    if (CIDRaddr == nil)
        CIDRaddr = DEFAULTCIDR;
	
    NSArray *split = [CIDRaddr componentsSeparatedByString: @"/"];
	localnetaddr = [self intFromIP:[split objectAtIndex:0]];

	NSLog(@"checking %@ = %u against %@ = %u", [split objectAtIndex:0], localnetaddr, ipaddr, tmpip);
		  
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
	
	if([ip_addr length] <= 7)
		return NULL;

	if (![self isInternal:ip_addr]){
		return NULL;
	}
	
	return [iplookuptable objectForKey:ip_addr];
}


+(NSString *) getIP:(NSString*)identifier{
	if (identifier == NULL)
		return NULL;
	for (NSString *key in iplookuptable){
		if ([[iplookuptable objectForKey:key] isEqualToString:identifier]){
			return key;
			
		}
	}
	return NULL;
}


+(NSString *) friendlynamefrommac:(NSString *) macaddr{
	
	NSString * resolvedname = NULL;
	
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
	DLog(@"MAC TABLE AS FOLLOWS");
	for (id key in maclookuptable){
		NSString *name = [maclookuptable objectForKey:key];
		DLog(@"%@    %@", key, name);
	}
}

+(void)printiptable{
	DLog(@"IP TABLE AS FOLLOWS");
	for (id key in iplookuptable){
		NSString *name = [iplookuptable objectForKey:key];
		DLog(@"%@    %@", key, name);
	}
}


+(void) newDeviceData:(NSNotification *) n{
    
    DeviceNameObject  *dobj = (DeviceNameObject *) [n object];
   
    NSString *mac = [self getidentifier:dobj.ipaddr];

    if (mac == nil){
        NSLog(@"--------------> Hmmm no mac for addr %@", dobj.ipaddr);
    }else{
        NSLog(@"NAME RESOLVER::::--------- %@ %@ %@", dobj.ipaddr,  dobj.name, mac);
        [maclookuptable setObject:[dobj name] forKey:mac];
        NSDictionary* dict = [NSDictionary dictionaryWithObject:[dobj name] forKey:mac];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nameChange" object:nil userInfo:dict];
    }

}


+(void) newLease:(NSNotification *) n{
	
	LeaseObject  *lobj = (LeaseObject *) [n object];
	
	if ([[lobj action] isEqualToString:@"del"]){
		return;
	}
	if (![[lobj action] isEqualToString:@"upd"]){
		[iplookuptable setObject:[lobj macaddr] forKey:[lobj ipaddr]];
	}else{
		DLog(@"UPDATE RECORD ----> updating mac/name %@/%@", [lobj name], [lobj macaddr]);
		[maclookuptable setObject:[lobj name] forKey:[lobj macaddr]];
		NSDictionary* dict = [NSDictionary dictionaryWithObject:[lobj name] forKey:[lobj macaddr]];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"nameChange" object:nil userInfo:dict];
	}
		
	NSString* humanname = [maclookuptable objectForKey:[lobj macaddr]];
	
	/*
	 * Only give the name of the machine as an IP address if our current name is an IP
	 * or if we don't yet have a name (i.e hwdb returns NULL for name)
	 */
	if (humanname == NULL || [self isIP:humanname]){
		humanname = [[lobj name] isEqualToString:@"NULL"] ? [lobj ipaddr] : [lobj name]; 
		[maclookuptable setObject:humanname forKey:[lobj macaddr]];
		[self writeMacTable];
	}
}

+(BOOL) isIP:(NSString *) string{
	struct in_addr pin;
	int success = inet_aton([string UTF8String], &pin);
	if (success == 1) return TRUE;
	return FALSE;
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
