//
//  RootViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DeviceViewController.h"
#import "ContentionAppAppDelegate.h"

@interface DeviceViewController (private)
-(void) newNetworkData:(NSNotification *) n;
@end

@implementation DeviceViewController

@synthesize sorteddata;
@synthesize vm;



#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	ViewManager *tmpvm = [[[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self] retain];
	[self setVm:tmpvm];
	[tmpvm release];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Devices";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
	
	/*
	 * Timer For testing
	 */
	//[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(update) userInfo:nil repeats:YES]; 
}


-(NSString *) getImage:(NSString *) s{
	return [DeviceImageLookup getImage:s];
}

-(float) getBandwidthProportion:(NSString *) n{
	return [NetworkData getDeviceBandwidthProportion:n];
}


-(void) touched: (int) tag viewname:(NSString *) name position: (int) index{
	NSLog(@"DEVICE VIEW AM TOUCHED>>>>-------------------------------------");
	if (tag == IMAGE){
		DeviceSubViewController *detail = [[DeviceSubViewController alloc] initWithNibName:@"DeviceSubView" bundle:nil nodename:name];
		detail.title = [NSString stringWithFormat:@"%@", name];
		ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.navigationControllerDevices pushViewController:detail animated: YES];
		[detail release];
	}
	
}


-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	[self.vm update:sorteddata];
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

