//
//  RootViewController.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ApplicationViewController.h"
#import "ContentionAppAppDelegate.h"

@interface ApplicationViewController (private)
-(void) newNetworkData:(NSNotification *) n;
@end

@implementation ApplicationViewController

@synthesize sorteddata;
@synthesize vm;



#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[DeviceImageLookup initialize];
	
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestApplicationData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	ViewManager *tmpvm = [[[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self] retain];
	[self setVm:tmpvm];
	[tmpvm release];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Applications";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
	
	/*
	 * Timer For testing
	 */
	//[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(update) userInfo:nil repeats:YES]; 
}


-(NSString *) getImage:(NSString *) s{
	return [ApplicationImageLookup getImage:s];
}

-(float) getBandwidthProportion:(NSString *) n{
	return [NetworkData getApplicationBandwidthProportion:n];
}


-(void) touched: (int) tag viewname:(NSString *) name position: (int) index{
	
	
	if (tag == LABEL){
		if (self.editing){
			DeviceView *deviceview = [self.vm viewForName:name];

			DeviceNameAlert *alert = [[DeviceNameAlert alloc] 
									  initWithTitle: @"Application Name" 
									  message:@"Specify the  Application Name"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  otherButtonTitles:@"OK", nil];
			[alert addTextFieldWithValue:[deviceview name] label:@"Application Name"];
			[alert setDeviceView:deviceview];
			
			UITextField *tf = [alert textFieldAtIndex:0];
			tf.clearButtonMode = UITextFieldViewModeWhileEditing;
			tf.keyboardType = UIKeyboardTypeAlphabet;
			tf.keyboardAppearance = UIKeyboardAppearanceAlert;
			tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
			tf.autocorrectionType = UITextAutocorrectionTypeNo;
			[alert show];
			
		}
	}
	
	if (tag == IMAGE){
		if (self.editing){
			CustomImagePicker *picker = [[CustomImagePicker alloc] initWithNibName:nil bundle:nil view:[self.vm viewForName:name]];			
			picker.title = @"select an image";
			
			ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			
			[delegate.navigationControllerApplications pushViewController:picker animated: YES];
			[picker release];
			
		}else{
			ApplicationSubViewController *detail = [[ApplicationSubViewController alloc] initWithNibName:nil bundle:nil nodename:name];
			detail.title = [NSString stringWithFormat:@"%@", name];
			ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.navigationControllerApplications pushViewController:detail animated: YES];
			[detail release];
		}
	}
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DeviceView *deviceView = ((DeviceNameAlert *) alertView).deviceView;
	
	if (deviceView != NULL){
		NSString* newname = [[alertView textFieldAtIndex:0] text];
		[NameResolver update:[deviceView identifier] newname:newname];
		[deviceView updateName:[[alertView textFieldAtIndex:0] text]];
	}
	//[NameResolver printmactable];
	
}



-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestApplicationData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	[self.vm update:sorteddata];
	
	NSEnumerator *enumerator = [self.sorteddata objectEnumerator];
	
	/*
	 NodeTuple* node;
	 
	 while ( (node = [enumerator nextObject])) {
	 //Window *w = [self.bytehistory objectForKey:[node name]];
	 //[node print];
	 //: w.lastpoll currentpoll:POLLNUMBER];
	 //[w print:[node name]];
	 }*/
	
	for (NodeTuple * node in self.sorteddata){
		NSLog(@"identity = %@ name is %@", [node identifier], [node name]);
		
	}
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

