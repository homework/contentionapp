//
//  ApplicationImageLookup.m
//  ContentionApp
//
//  Created by Tom Lodge on 23/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationImageLookup.h"

@interface ApplicationImageLookup (PrivateMethods)
+(void) writelookuptable;
@end

@implementation ApplicationImageLookup



static NSMutableDictionary *lookuptable;
static BOOL init = false;

+(void) initialize{
	if (!init){
		
		NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *path = [docsDirectory stringByAppendingPathComponent:@"appimagetable.txt"];
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

+(NSString *) getDefaultImage:(NSString *) application{
	if (application == NULL){
		return @"unknown.png";
	}
	
	if ([application isEqualToString:@"hwdb"])
		return @"hwdb.png";
	
	if ([application isEqualToString:@"macromedia-fcs"])
		return @"iplayer.png";
	
	if ([application hasPrefix:@"https"])
		return @"websecure.png";
	
	if ([application hasPrefix:@"http"])
		return @"web.png";
	
	if ([application isEqualToString:@"ssh"])
		return @"telnet.png";
	
	if ([application hasPrefix:@"imap"])
		return @"email.png";
	
	return @"unknown.png";
	
}

+(NSString *) getImage:(NSString *) application{
	
	NSString * result = [lookuptable objectForKey:application];
	if (result != NULL)
		return result;
	
	return [self getDefaultImage:application];
}


+(NSString *) getApplicationType:(NSString *) application{
	if (application == NULL){
		return @"unknown";
	}
	if ([application isEqualToString:@"macromedia-fcs"])
		return @"iplayer";
	
	if ([application hasPrefix:@"https"])
		return @"websecure";
	
	if ([application hasPrefix:@"http"])
		return @"web";
	
	if ([application isEqualToString:@"ssh"])
		return @"telnet";
	
	if ([application hasPrefix:@"imap"])
		return @"email";
	
	return application;	
}

+(void) update:(NSString *)image forNode:(NSString *)app{
	if (!init)
		[self initialize];
	
	[lookuptable setObject:image forKey:app];
	[self writelookuptable];
}

+(void) writelookuptable{
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"appimagetable.txt"];
	[lookuptable writeToFile:path atomically:YES];
}

-(void) dealloc{
	[lookuptable release];
	[super dealloc];
}

@end
