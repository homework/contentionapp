//
//  RootViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceView.h"
#import "DeviceSubViewController.h"
#import "ContentionAppAppDelegate.h"

@implementation DeviceViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Devices";
	CGRect frame = CGRectMake(0.0,0.0, 320, 460);
	DeviceView *aView = [[DeviceView alloc] initWithFrame:frame];
	aView.backgroundColor = [UIColor whiteColor];
	aView.delegate = self;
	[self.view addSubview:aView];
	
	[aView release];
}

-(void) touched:(NSString *)device{
	DeviceSubViewController *applicationdetail = [[DeviceSubViewController alloc] initWithNibName:@"DeviceSubView" bundle:nil];
	applicationdetail.title = [NSString stringWithFormat:@"%@", device];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerDevices pushViewController:applicationdetail animated: YES];
	[applicationdetail release];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

