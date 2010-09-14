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
@end

int count;
NSMutableDictionary *iplookuptable;
NSMutableDictionary *maclookuptable;

NSString* netmask  = @"192.168.9";
static BOOL init = FALSE;

@implementation NameResolver

+(void) initialize{
	if (init)
		return;
	
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollComplete:) name:@"pollComplete" object:nil];
	init = TRUE;
	
}




+(BOOL) isInternal:(NSString *) ipaddr{
	if([ipaddr length] <= 9){
		return  FALSE;
	}
	return  ([[ipaddr substringToIndex:9] isEqualToString:netmask]);
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
	
	if (![self isInternal:ip_addr])
		return NULL;
	
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
+(void) pollComplete:(NSNotification *) n{
	//[self printmactable];
	//[self printiptable];
}

+(void) newLease:(NSNotification *) n{
	
	LeaseObject  *lobj = (LeaseObject *) [n object];
	
	[iplookuptable setObject:[lobj macaddr] forKey:[lobj ipaddr]];
	NSString* humanname = [maclookuptable objectForKey:[lobj macaddr]];
	
	if (humanname == NULL){
		humanname = [[lobj name] isEqualToString:@" "] ? [lobj ipaddr] : [lobj name]; 
		//NSLog(@"new lease, setting MAC table %@ %@", [lobj macaddr], humanname);
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
