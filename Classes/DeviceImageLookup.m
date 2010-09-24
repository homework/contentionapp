//
//  DeviceImageLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceImageLookup.h"

@interface DeviceImageLookup (PrivateMethods)
+(void) writelookuptable;
+(NSString *) getDefault:(NSString *) program;
@end


@implementation DeviceImageLookup


static NSMutableDictionary *lookuptable;
static BOOL init = false;

+(void) initialize{
	if (!init){
		NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *path = [docsDirectory stringByAppendingPathComponent:@"deviceimagetable.txt"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if ([fileManager fileExistsAtPath:path]){
			lookuptable = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] retain];
		}else{
			lookuptable = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		}
		
		[fileManager release];
		
		init = TRUE;
	}
}

+(NSString *) getImage:(NSString *) program{
	
	NSString *imagename;
	
	if ( (imagename = [lookuptable objectForKey:program]) == NULL){
		return [self getDefault:program];
	}
	
	return imagename;							  
}

+(NSString *) getDefault:(NSString *) program{
	return @"unknown.png";	
}

+(void) update:(NSString *) image forNode:(NSString *) node{
	[lookuptable setObject:image forKey:node];
	[self writelookuptable];
}

+(void) writelookuptable{
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"deviceimagetable.txt"];
	[lookuptable writeToFile:path atomically:YES];
	
}

-(void) dealloc{
	[lookuptable release];
	[super dealloc];
}

@end
