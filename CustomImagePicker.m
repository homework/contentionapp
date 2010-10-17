//
//  CustomImagePicker.m
//  ContentionApp
//
//  code taken from:
//  http://www.raywenderlich.com/130/how-to-write-a-custom-image-picker-like-uiimagepicker/
//
#import "CustomImagePicker.h"
#import "ContentionAppAppDelegate.h"

@implementation CustomImagePicker

@synthesize deviceView;
@synthesize parent;

static  NSArray* _thumbs;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil view:(DeviceView*) v imagelist:(NSArray*)images parent:(UIViewController *)p{
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	 [self setDeviceView:v];
	 _thumbs = images ;
	 [self setParent: p];
 }
 return self;
 }
 

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	UIScrollView *view = [[UIScrollView alloc] 
						  initWithFrame:[[UIScreen mainScreen] bounds]];
	
	int row = 0;
	int column = 0;
	for(int i = 0; i < _thumbs.count; ++i) {
		
		UIImage *thumb = [UIImage imageNamed:[_thumbs objectAtIndex:i]];
		UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*100+24, row*90+10, 84, 84);
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
	
	[view setContentSize:CGSizeMake(320, (row+1) * 90 + 10)];	
	self.view = view;
	[view release];	
	[super viewDidLoad];
}

- (IBAction)buttonClicked:(id)sender {
	UIButton *button = (UIButton *)sender;
	NSString *selectedImage = [_thumbs objectAtIndex:button.tag];
	
	if (deviceView != NULL){
		[deviceView updateImage:selectedImage];
	}
	
	[parent updateImage:selectedImage forNode:[deviceView identifier]];
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
	//[_thumbs release];
    [super dealloc];
}


@end
