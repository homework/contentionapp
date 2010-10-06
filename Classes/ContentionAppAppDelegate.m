//
//  ContentionAppAppDelegate.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ContentionAppAppDelegate.h"
#import "DeviceViewController.h"

@interface ContentionAppAppDelegate (PrivateMethods)
-(void) setUpAlerts;
@end


@implementation ContentionAppAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationControllerDevices;
@synthesize navigationControllerApplications;
@synthesize pollingThread;
@synthesize alert;
@synthesize alerted;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[RPCSend initrpc];
	[UserEventLogger logstartup];
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
	
	[PortLookup initPorts];
	[FlowAnalyser initTables];
	[NameResolver initialize];
	[NetworkData initialize];
	
	PollingThread *aPollingThread = [[PollingThread alloc] init];
	[self setPollingThread:aPollingThread];	
	[aPollingThread release];
	[self setUpAlerts];
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionLost:) name:@"disconnected" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionRegained:) name:@"connected" object:nil];
	[NSThread detachNewThreadSelector:@selector(startpolling:) toTarget:pollingThread withObject:nil];
	return YES;
}

-(void) setUpAlerts{
	alerted = FALSE;
	UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Cannot connect to your router.\n I will continue to retry.\nIf this message does not disappear\nplease check your connection and restart." delegate:self cancelButtonTitle:nil otherButtonTitles:nil]; 
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];	
	indicator.center = CGPointMake(140, 150);
	[indicator startAnimating];
	[tmpAlert addSubview:indicator];
	[indicator release];
	[self setAlert:tmpAlert];
	[tmpAlert release];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[UserEventLogger logshutdown];
}

-(void) connectionLost:(NSNotification *) n{
	if (!alerted){
		alerted = TRUE;
		[alert show]; 
	}
}

-(void) connectionRegained:(NSNotification *) n{
	if (alerted){
		alerted = FALSE;
		[alert dismissWithClickedButtonIndex:0 animated:YES]; 
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationControllerDevices release];
	[navigationControllerApplications release];
	[tabBarController release];
	[pollingThread release];
	[alert release];
	[window release];
	[super dealloc];
}


@end

