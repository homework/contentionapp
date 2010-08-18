//
//  ContentionAppAppDelegate.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ContentionAppAppDelegate.h"
#import "DeviceViewController.h"


@implementation ContentionAppAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationControllerDevices;
@synthesize navigationControllerApplications;
@synthesize pollingThread;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch
    
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
	
	[PortLookup initPorts];
	[FlowAnalyser initTables];
	[NameResolver initialize];
	[NetworkData initialize];
	PollingThread *aPollingThread = [[PollingThread alloc] init];
	[self setPollingThread:aPollingThread];	
	[aPollingThread release];
	[NSThread detachNewThreadSelector:@selector(startpolling:) toTarget:pollingThread withObject:nil];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationControllerDevices release];
	[navigationControllerApplications release];
	[window release];
	[super dealloc];
}


@end

