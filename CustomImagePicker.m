//
//  CustomImagePicker.m
//  ContentionApp
//
//  Created by Tom Lodge on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomImagePicker.h"
#import "ContentionAppAppDelegate.h"

@implementation CustomImagePicker

@synthesize deviceView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil view:(DeviceView*) v {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	 [self setDeviceView:v];
 }
 return self;
 }
 

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

static  NSArray* _thumbs;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	_thumbs = [[NSArray arrayWithObjects: @"mac.png", @"phone.png", @"router.png", @"laptop.png", @"iphone.png", @"sound.png", nil] retain];

	
	UIScrollView *view = [[UIScrollView alloc] 
						  initWithFrame:[[UIScreen mainScreen] bounds]];
	
	int row = 0;
	int column = 0;
	for(int i = 0; i < _thumbs.count; ++i) {
		
		UIImage *thumb = [UIImage imageNamed:[_thumbs objectAtIndex:i]];
		UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*100+24, row*80+10, 84, 84);
		[button setImage:thumb forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonClicked:) 
		 forControlEvents:UIControlEventTouchUpInside];
		button.tag = i; 
		[view addSubview:button];
		
		if (column == 2) {
			column = 0;
			row++;
		} else {
			column++;
		}
	}
	
	[view setContentSize:CGSizeMake(320, (row+1) * 80 + 10)];	
	self.view = view;
	[view release];	
	[super viewDidLoad];
}

- (IBAction)buttonClicked:(id)sender {
	
	//NSLog(@"great button clicked:::");
	UIButton *button = (UIButton *)sender;
	//NSLog(@"button tag is %i", button.tag);
	NSString *selectedImage = [_thumbs objectAtIndex:button.tag];
	
	//NSLog(@"selected image %@ for %@", selectedImage, name);
	[DeviceImageLookup update:selectedImage forNode:[deviceView identifier]];
	ContentionAppAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navigationControllerDevices popViewControllerAnimated:YES];
	if (deviceView != NULL){
		[deviceView updateImage:selectedImage];
	}
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
	[_thumbs release];
    [super dealloc];
}


@end
