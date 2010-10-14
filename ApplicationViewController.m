//
//  RootViewController.m
//  ContentionApp
//

#import "ApplicationViewController.h"
#import "ContentionAppAppDelegate.h"

@interface ApplicationViewController (private)
-(void) newNetworkData:(NSNotification *) n;
-(void) showDetail:(NSString *) identifier position: (int) index;
-(void) editName:(NSString *) identifier;
-(void) editImage:(NSString *) identifier;
-(void) addObservers;
-(void) setUpViewManager;
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
	[self setUpViewManager];
	[self addObservers];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Applications";
}


- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[UserEventLogger logscreenchange:@"applications"];
}
	

-(void) touched: (int) tag viewname:(NSString *) identifier position: (int) index{
	
	if (tag == LABEL){
		if (self.editing){
			[self editName:identifier];
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



-(void) updateImage:(NSString*) image forNode:(NSString*)identifier{
	[ApplicationImageLookup update:image forNode:identifier];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerApplications popViewControllerAnimated:YES];
	[UserEventLogger logimagechange:identifier  newimage:image screen:@"application"];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DeviceView *deviceView = ((NameAlert *) alertView).deviceView;
	
	if (deviceView != NULL){
		NSString* newname = [[alertView textFieldAtIndex:0] text];
		if (![[newname stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
			[NameResolver update:[deviceView identifier] newname:newname];
			[deviceView updateName:[[alertView textFieldAtIndex:0] text]];
			[UserEventLogger lognamechange:[deviceView identifier] newname:newname screen:@"application"];
		}
	}
}

-(NSString *) getImage:(NSString *) s{
	return [ApplicationImageLookup getImage:s];
}

-(float) getBandwidthProportion:(NSString *) n{
	return [NetworkData getApplicationBandwidthProportion:n];
}


#pragma mark -
#pragma mark Private Methods

-(void) newNetworkData:(NSNotification *) n{
	self.sorteddata = [[NetworkData getLatestApplicationData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	[self.vm update:sorteddata];
	
}

-(void) setUpViewManager{
	self.sorteddata = (NSMutableArray*)[[NetworkData getLatestApplicationData] sortedArrayUsingSelector:@selector(sortByValue:)] ;
	ViewManager *tmpvm = [[ViewManager alloc] initWithView:self.view data:self.sorteddata viewcontroller:self];
	[self setVm:tmpvm];
	[tmpvm release];
}

-(void) addObservers{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNetworkData:) name:@"newFlowData" object:nil];	
	
}

-(void) showDetail:(NSString *) identifier position: (int) index{
	ApplicationSubViewController *detail = [[ApplicationSubViewController alloc] initWithNibName:nil bundle:nil nodename:identifier];
	detail.title = [NameResolver friendlynamefrommac: identifier];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerApplications pushViewController:detail animated: YES];
	[detail release];
	[UserEventLogger logdrilldown:identifier position:index screen:@"application"];
}

-(void) editImage:(NSString *) identifier{
	CustomImagePicker *picker = [[CustomImagePicker alloc] initWithNibName:nil bundle:nil view:[self.vm viewForName:identifier] imagelist:[ImageList getList:@"applications"] parent:self];			
	picker.title = picker.title = [NSString stringWithFormat:@"%@ image", identifier];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerApplications pushViewController:picker animated: YES];
	[picker release];
}

-(void) editName:(NSString *) identifier{
	DeviceView *deviceview = [self.vm viewForName:identifier];
	
	NameAlert *alert = [[NameAlert alloc] 
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





#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

