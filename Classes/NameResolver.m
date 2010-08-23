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
NSMutableDictionary *lookuptable;
NSString* netmask  = @"192.168.9";

@implementation NameResolver

+(void) initialize{
	lookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newLease:) name:@"newLeaseDataReceived" object:nil];
	
}

+(NSString *) lookup:(NSString *)ip_src destination:(NSString *)ip_dst{
	//return [NSString stringWithFormat:@"device%d", count++];
	LeaseRecord *record = [lookuptable objectForKey:ip_src];
	if (record != NULL){
		if ( ![record.name isEqualToString:@" "]){
			return record.name;
		}
		return ip_src;
	}
						
	record = [lookuptable objectForKey:ip_dst];
	if (record != NULL){ 
		if ( ![record.name isEqualToString:@" "]){
			return record.name;
		}
		return ip_dst;
	}
	
	
	
	if([ip_src length] > 9){ 
		NSLog(@"ip src substring is %@", [ip_src substringToIndex:9]);
		
		if ([[ip_src substringToIndex:9] isEqualToString:netmask]){
			return ip_src;
		}
	}else{
		NSLog(@"ip src is %@", ip_src);
	}
	
	if([ip_dst length] > 9){
		NSLog(@"ip dst substring is %@", [ip_dst substringToIndex:9]);
		if ([[ip_dst substringToIndex:9] isEqualToString:netmask])
			return ip_dst;	
	}else{
		NSLog(@"---------> ip dst is %@", ip_dst);
	}

	return @"unknown";
}

+(void) newLease:(NSNotification *) n{
	LeaseObject  *lobj = (LeaseObject *) [n object];
	LeaseRecord * record;
	record = [lookuptable objectForKey:[lobj ipaddr]];
			  
	if (record == NULL){
		record = [[[LeaseRecord alloc] initWithValues:[lobj macaddr] name:[lobj name]] retain];
		[lookuptable setObject:record forKey:[lobj ipaddr]];
	}else{
		[record setMacaddr:[lobj macaddr]];
		[record setName:[lobj name]];
	}
}

-(void) dealloc{
	[lookuptable release];
	[super dealloc];
}


@end
