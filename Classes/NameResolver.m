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

@end

int count;
NSMutableDictionary *iplookuptable;
NSMutableDictionary *maclookuptable;
NSMutableDictionary *noleasetable;

NSString* netmask  = @"192.168.9";

@implementation NameResolver

+(void) initialize{
	iplookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	maclookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	noleasetable   = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	//userdefinednames = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLease:) name:@"newLeaseDataReceived" object:nil];
	
}

+(NSString *) lookup:(NSString *) macaddr{
	
	NSString * resolvedname = NULL;
	
	//NSString* macaddr = [iplookuptable objectForKey:ip_addr];

	resolvedname = NULL;
	
	if (macaddr != NULL){
		resolvedname = [maclookuptable objectForKey:macaddr];
	}
	
	/*else{ //check if it's in the nolease table
		resolvedname = [noleasetable objectForKey:ip_addr];	
	}*/
	
	//NSLog(@"returning %@",  (resolvedname == NULL) ? ip_addr:resolvedname);
	return (resolvedname == NULL) ? macaddr:resolvedname;
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

+(NSString *) getidentifier:(NSString *)ip_src destination:(NSString *)ip_dst{
	NSString * ipaddr = NULL;
	
	
	if([ip_src length] > 9){ 
		if ([[ip_src substringToIndex:9] isEqualToString:netmask]){
			ipaddr =  ip_src;
		}
	}
	
	if (ipaddr == NULL){
		if([ip_dst length] > 9){ 
			if ([[ip_dst substringToIndex:9] isEqualToString:netmask]){
				ipaddr =  ip_dst;
			}
		}
	}
	
	if (ipaddr == NULL){
		return NULL;
	}
	
	NSString* macaddr =  [iplookuptable objectForKey:ipaddr];

	return macaddr;
}

+(NSString *) lookup:(NSString *)ip_src destination:(NSString *)ip_dst{
	
	//THIS NEEDS TO BE DONE IN A siNGLE stagE - IE llokup ipsrc
	//thenn llokup ipdest!!
	
	/*
	 * First check if we have an ipaddr for this 
	 */
	
	//find the local address of the two;
	
	NSString * ipaddr = NULL;
	
	
	if([ip_src length] > 9){ 
		if ([[ip_src substringToIndex:9] isEqualToString:netmask]){
			ipaddr =  ip_src;
		}
	}
	
	if (ipaddr == NULL){
		if([ip_dst length] > 9){ 
			if ([[ip_dst substringToIndex:9] isEqualToString:netmask]){
				ipaddr =  ip_dst;
			}
		}
	}
	
	if (ipaddr == NULL){ //not found
		return NULL;
	}
	
	NSString* macaddr = [iplookuptable objectForKey:ipaddr];
	
	if (macaddr != NULL){
		return [maclookuptable objectForKey:macaddr];
	}
	else{
		return NULL;
	}
	//return [self lookup:ipaddr];
}

+(void) update:(NSString *)macaddr newname:(NSString*) newname{
	/*NSString *thekey = NULL;
	
	for (id key in maclookuptable){
		NSString *name = [maclookuptable objectForKey:key];
		if ([name isEqualToString:oldname]){
			thekey = key;
			break;
		}
	}
	if(thekey != NULL){*/
	
		[maclookuptable setObject:newname forKey:macaddr];
	/*}else{
		[noleasetable setObject:newname forKey:oldname];
	}*/
}

+(void)printmactable{
	NSLog(@"MAC TABLE AS FOLLOWS");
	for (id key in maclookuptable){
		NSString *name = [maclookuptable objectForKey:key];
		NSLog(@"%@    %@", key, name);
	}
}

+(void) newLease:(NSNotification *) n{
	
	LeaseObject  *lobj = (LeaseObject *) [n object];
	
	NSLog(@"new lease, setting IP table %@ %@", [lobj ipaddr], [lobj macaddr]);
	[iplookuptable setObject:[lobj macaddr] forKey:[lobj ipaddr]];
	
	NSString* humanname = [maclookuptable objectForKey:[lobj macaddr]];
	
	if (humanname == NULL){
		humanname = [noleasetable objectForKey:[lobj ipaddr]];
		if (humanname == NULL)
			humanname = [[lobj name] isEqualToString:@" "] ? [lobj ipaddr] : [lobj name]; 
		NSLog(@"new lease, setting MAC table %@ %@", [lobj macaddr], humanname);
		[maclookuptable setObject:humanname forKey:[lobj macaddr]];
	}
}

-(void) dealloc{
	[maclookuptable release];
	[iplookuptable release];
	[super dealloc];
}


@end
