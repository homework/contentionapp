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
	[DeviceImageLookup initialize];
	
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	ViewManager *tmpvm = [[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self];
	[self setVm:tmpvm];
	[tmpvm release];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Devices";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connected:) name:@"connected" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnected:) name:@"disconnected" object:nil];
	
	/*
	 * Timer For testing
	 */
	//[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(update) userInfo:nil repeats:YES]; 
}


-(void) connected:(NSNotification *) n{
	[self.vm connected];
}

-(void) disconnected:(NSNotification *) n{
	[self.vm disconnected];
}

-(NSString *) getImage:(NSString *) s{
	return [DeviceImageLookup getImage:s];
}

-(float) getBandwidthProportion:(NSString *) n{
	return [NetworkData getDeviceBandwidthProportion:n];
}


-(void) touched: (int) tag viewname:(NSString *) identifier position: (int) index{
	
	
	
	if (tag == LABEL){
		if (self.editing){
			DeviceView *deviceview = [self.vm viewForName:identifier];
			
			
			
			DeviceNameAlert *alert = [[DeviceNameAlert alloc] 
								  initWithTitle: @"Device Name" 
								  message:@"Specify the  Device Name"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"OK", nil];
			[alert addTextFieldWithValue:[deviceview name] label:@"Device Name"];
			[alert setDeviceView:deviceview];
			
			// Name field
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
			 _thumbs = [[NSArray arrayWithObjects: @"mac.png", 
															@"phone.png", 
															@"router.png",
															@"laptop.png", 
															@"iphone.png", 
															@"sound.png",
															@"blackberry.png",
															@"game.png",
															@"wii.png",
															@"ipad.png",
															@"printer.png",
															@"printserver.png",
															@"psp.png",
															@"macmini.png",
															@"unknown.png",
															nil] retain];
			
			
			CustomImagePicker *picker = [[CustomImagePicker alloc] initWithNibName:nil bundle:nil view:[self.vm viewForName:identifier] imagelist:_thumbs parent:self];			
			
			picker.title = @"select an image";
			
			ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			
			[delegate.navigationControllerDevices pushViewController:picker animated: YES];
			[picker release];
			
		}else{
			DeviceSubViewController *detail = [[DeviceSubViewController alloc] initWithNibName:@"DeviceSubView" bundle:nil nodename:identifier];
			detail.title = [NSString stringWithFormat:@"%@", [NameResolver friendlynamefrommac:identifier]];
			ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.navigationControllerDevices pushViewController:detail animated: YES];
			[detail release];
			[UserEventLogger logdrilldown:identifier position:index screen:@"device"];
			
		}
	}
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DeviceView *deviceView = ((DeviceNameAlert *) alertView).deviceView;
	
	if (deviceView != NULL){
		NSString* newname = [[alertView textFieldAtIndex:0] text];
		[NameResolver update:[deviceView identifier] newname:newname];
		[deviceView updateName:[[alertView textFieldAtIndex:0] text]];
		[UserEventLogger lognamechange:[deviceView identifier]  newname:newname screen:@"device"];
	}
	//[NameResolver printmactable];
}




-(void) updateImage:(NSString*) image forNode:(NSString*)identifier{
	[DeviceImageLookup update:image forNode:identifier];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerDevices popViewControllerAnimated:YES];
	[UserEventLogger logimagechange:identifier  newimage:image screen:@"device"];
	
}


-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
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

