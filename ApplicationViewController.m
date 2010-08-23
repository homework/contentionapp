//
//  ApplicationViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationViewController.h"


@implementation ApplicationViewController
@synthesize sorteddata;
@synthesize appView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestApplicationData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Programs";
	CGRect frame = CGRectMake(0.0,0.0, 320, 460);
	self.appView = [[ApplicationView alloc] initWithFrame:frame nodes:[self sorteddata]];
	[self.view addSubview:self.appView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
	
	/*
	 * Timer For testing
	 */
	//[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(update) userInfo:nil repeats:YES]; 
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
	
	self.sorteddata = [[NetworkData getLatestApplicationData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	
	//NSEnumerator *enumerator = [self.sorteddata objectEnumerator];
	//NodeTuple* node;
	
	//while ( (node = [enumerator nextObject])) {
	//	[node print];
	//}
	
	[self.appView update:self.sorteddata];
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
