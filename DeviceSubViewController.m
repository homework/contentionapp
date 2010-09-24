//
//  DeviceSubViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceSubViewController.h"



@implementation DeviceSubViewController

@synthesize sorteddata;
@synthesize vm;
@synthesize node;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil nodename:(NSString*) n {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self setNode:n];
		self.sorteddata = (NSMutableArray*)[[NetworkData getLatestApplicationDataForNode:node] sortedArrayUsingSelector:@selector(sortByValue:)] ;
		ViewManager *tmpvm = [[[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self ] retain];
		
		[self setVm:tmpvm];
		[tmpvm release];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
		
		
	}
    return self;
}

-(float) getBandwidthProportion:(NSString *) a{
	return [NetworkData getDeviceAppBandwidthProportion:self.node application:a];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
	[super viewDidLoad];
	
		/*
	 * Timer For testing
	 */
	//[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(update) userInfo:nil repeats:YES]; 
	
}


-(NSString *) getImage:(NSString *) s{
	return [ApplicationImageLookup getImage:s];
}

-(void) touched: (int) tag viewname:(NSString *) name position: (int) index{
	
}


-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestApplicationDataForNode:node] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	[self.vm update:sorteddata];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
