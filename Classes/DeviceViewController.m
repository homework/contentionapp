//
//  RootViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DeviceViewController.h"
#import "DevicesView.h"
#import "DeviceSubViewController.h"
#import "ContentionAppAppDelegate.h"

@implementation DeviceViewController

@synthesize sorteddata;
@synthesize devicesView;

#pragma mark -
#pragma mark View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"VVVVVIEW DID LOAD!!");
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Devices";
	CGRect frame = CGRectMake(0.0,0.0, 320, 460);
	self.devicesView = [[DevicesView alloc] initWithFrame:frame nodes:[self sorteddata]];
	[self.view addSubview:self.devicesView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
	
	/*
	 * Timer For testing
	 */
	//[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(update) userInfo:nil repeats:YES]; 
}


-(void) touched:(NSString *)device{
	DeviceSubViewController *applicationdetail = [[DeviceSubViewController alloc] initWithNibName:@"DeviceSubView" bundle:nil];
	applicationdetail.title = [NSString stringWithFormat:@"%@", device];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerDevices pushViewController:applicationdetail animated: YES];
	[applicationdetail release];
}


-(void) printTable{
	
	NSEnumerator *enumerator = [self.sorteddata objectEnumerator];
	
	NodeTuple* node;
	
	while ( (node = [enumerator nextObject])) {
		//Window *w = [self.bytehistory objectForKey:[node name]];
		[node print];
		//: w.lastpoll currentpoll:POLLNUMBER];
		//[w print:[node name]];
	}
}

-(void) newNetworkData:(NSNotification *) n{
	//[sorteddata removeAllObjects];
	NSLog(@"new FLOW data");
	self.sorteddata = [[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	
	NSEnumerator *enumerator = [self.sorteddata objectEnumerator];
	/*NodeTuple* node;
	
	while ( (node = [enumerator nextObject])) {
		[node print];
	}*/
	
	[self.devicesView update:self.sorteddata];
}


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

