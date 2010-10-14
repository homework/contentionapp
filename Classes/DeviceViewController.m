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
-(void) showDetail:(NSString *) identifier position: (int) index;
-(void) editImage:(NSString *) identifier;
-(void) setUpHoverView;
-(void) addObservers;
-(void) setUpViewManager;
-(void) editName:(NSString *) identifier;
-(void) showHoverView:(BOOL)show identifier:(NSString *) identifier;
@end

NSString *Show_HoverView = @"SHOW";

@implementation DeviceViewController

@synthesize sorteddata;
@synthesize vm;
@synthesize hoverView;

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[DeviceImageLookup initialize];
	[self setUpHoverView];
	[self setUpViewManager];
	[self addObservers];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Devices";
}


- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[UserEventLogger logscreenchange:@"devices"];
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
			[self editName: identifier];
		}else{
			[self showHoverView:YES identifier:identifier];
		}
	}
	
	if (tag == IMAGE){
		if (self.editing){
			[self editImage:identifier];
			
		}else{
			[self showDetail:identifier position:index];
		}
	}
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DeviceView *deviceView = ((NameAlert *) alertView).deviceView;
	
	if (deviceView != NULL){
		NSString* newname = [[alertView textFieldAtIndex:0] text];
		if (![[newname stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
			if (![newname isEqualToString:[NameResolver friendlynamefrommac:[deviceView identifier]]]){
				[NameResolver update:[deviceView identifier] newname:newname];
				[deviceView updateName:[[alertView textFieldAtIndex:0] text]];
				[UserEventLogger lognamechange:[deviceView identifier]  newname:newname screen:@"device"];
				[UserEventLogger updateLeases:[deviceView identifier] newname:newname];
			}
		}
	}
}


-(void) updateImage:(NSString*) image forNode:(NSString*)identifier{
	[DeviceImageLookup update:image forNode:identifier];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerDevices popViewControllerAnimated:YES];
	[UserEventLogger logimagechange:identifier  newimage:image screen:@"device"];
	
}


#pragma mark -
#pragma mark Private Methods

-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	[self.vm update:sorteddata];
	
	for (NodeTuple* tp in sorteddata){
		DLog(@"%@   %d", [tp name], [tp value]); 
	}
}

-(void) addObservers{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];
}

-(void) setUpViewManager{
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestNodeData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	ViewManager *tmpvm = [[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self];
	[self setVm:tmpvm];
	[tmpvm release];
}

-(void) setUpHoverView{
	CGRect frame = CGRectMake(round((self.view.frame.size.width - 160) / 2.0),  self.view.frame.size.height - 150, self.view.frame.size.width / 2.0, self.view.frame.size.height / 8.0);
	HoverView *hv = [[HoverView alloc] initWithFrame:frame];
	hv.alpha = 0.0;
	hv.backgroundColor = [UIColor clearColor];
	[self setHoverView:hv];
	[self.view addSubview:hoverView];
	[hv release];
}


-(void) showDetail:(NSString *) identifier position: (int) index{
	DeviceSubViewController *detail = [[DeviceSubViewController alloc] initWithNibName:@"DeviceSubView" bundle:nil nodename:identifier];
	detail.title = [NSString stringWithFormat:@"%@", [NameResolver friendlynamefrommac:identifier]];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerDevices pushViewController:detail animated: YES];
	[detail release];
	[UserEventLogger logdrilldown:identifier position:index screen:@"device"];
}

-(void) editImage:(NSString *) identifier{
	CustomImagePicker *picker = [[CustomImagePicker alloc] initWithNibName:nil bundle:nil view:[self.vm viewForName:identifier] imagelist:[ImageList getList:@"devices"] parent:self];			
	
	picker.title = [NSString stringWithFormat:@"%@ image", [NameResolver friendlynamefrommac:identifier]];
	
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.navigationControllerDevices pushViewController:picker animated: YES];
	[picker release];
}

-(void) editName:(NSString *) identifier{
	DeviceView *deviceview = [self.vm viewForName:identifier];
	
	NameAlert *alert = [[NameAlert alloc] 
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

- (void)showHoverView:(BOOL)show identifier:(NSString*) identifier
{
	// reset the timer
	[myTimer invalidate];
	[myTimer release];
	myTimer = nil;
	
	if (identifier != nil){
		float bw = [NetworkData getCurrentBandwidth:identifier];
		NSString* bwidth;
		
		if (bw >= 1024){
			bwidth = [NSString stringWithFormat:@"%.2f Mbps", bw/1024 ];
		}else{
			bwidth = [NSString stringWithFormat:@"%.2f Kbps", bw];
		}
		 
		hoverView.bandwidthLabel.text= bwidth;
	}else{
		hoverView.bandwidthLabel.text = @"";	
	}
	
	// fade animate the view out of view by affecting its alpha
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	if (show)
	{
		// as we start the fade effect, start the timeout timer for automatically hiding HoverView
		hoverView.alpha = 1.0;
		myTimer = [[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO] retain];
		[[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
	}
	else
	{
		hoverView.alpha = 0.0;
	}
	
	[UIView commitAnimations];
}

- (void)timerFired:(NSTimer *)timer
{
	// time has passed, hide the HoverView
	[self showHoverView: NO identifier:nil];
}


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

