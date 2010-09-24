    //
//  ApplicationSubViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 31/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationSubViewController.h"


@implementation ApplicationSubViewController

@synthesize sorteddata;
@synthesize vm;
@synthesize node;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil nodename:(NSString*) n {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self setNode:n];
		self.sorteddata = (NSMutableArray*)[[NetworkData getLatestDeviceDataForApplication:node] sortedArrayUsingSelector:@selector(sortByValue:)] ;
		ViewManager *tmpvm = [[[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self ] retain];
		
		[self setVm:tmpvm];
		[tmpvm release];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
		
		
	}
    return self;
}

-(float) getBandwidthProportion:(NSString *) device{
	return [NetworkData getAppDeviceBandwidthProportion:self.node device:device];
}

-(NSString *) getImage:(NSString *) s{
	return [DeviceImageLookup getImage:s];
}

-(void) touched: (int) tag viewname:(NSString *) name position: (int) index{

}


-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestDeviceDataForApplication:node] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	[self.vm update:sorteddata];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
