//
//  ContentionAppAppDelegate.h
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationViewController.h"
#import "PollingThread.h"
#import "PortLookup.h"
#import "FlowAnalyser.h"
#import "NameResolver.h"
#import  "NetworkData.h"

@interface ContentionAppAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	BOOL alerted;
	UIAlertView *alert;
	UITabBarController *tabBarController;
	PollingThread *pollingThread;
    MyNavigationViewController *navigationControllerDevices;
	MyNavigationViewController *navigationControllerApplications;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyNavigationViewController *navigationControllerDevices;
@property (nonatomic, retain) IBOutlet MyNavigationViewController *navigationControllerApplications;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) PollingThread *pollingThread;
@property (nonatomic, retain) UIAlertView* alert;
@property (nonatomic, assign) BOOL alerted;
@end

