
#import "DeviceView.h"


@implementation DeviceView

@synthesize deviceImage;
@synthesize name;
@synthesize namelabel;

-(id) initWithValues:(NSString *) nodename position:(int) position{
	UIImage *image = [UIImage imageNamed:@"skype.png"];
	CGRect frame = CGRectMake(0, 0, 320, 200);
	
	if (self = [self initWithFrame:frame]){
		self.opaque = NO;
		deviceImage = image;
		self.name = nodename;
		//namelabel = [ [UILabel alloc ] initWithFrame:CGRectMake((self.bounds.size.width / 2) - 200,0.0, 150.0, 43.0) ];
		namelabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0,0.0, 150.0, 43.0) ];
		namelabel.textAlignment =  UITextAlignmentCenter;
		namelabel.textColor = [UIColor whiteColor];
		namelabel.backgroundColor = [UIColor blackColor];
		namelabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(16.0)];
		namelabel.text = nodename;
		[self updateMyPosition:position];
		[self addSubview:namelabel];
		
		// Load the display strings
	}
	return self;
	
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
		UITouch *touch = [touches anyObject];
	
	// Only move the placard view if the touch was in the placard view
	CGPoint thePoint = [touch locationInView:self];
	CGRect labbounds = self.namelabel.bounds;
	
	if (CGRectContainsPoint (labbounds,thePoint)){
		NSLog(@"label touched");

	}else{
		NSLog(@"something else touched");
	}
}
-(void) updateMyPosition:(int)p{
	position = p;
	/*
	if (p >= 3){
		//namelabel.hidden = YES;
		position = p;
	}else{
		//namelabel.hidden = NO;
	}*/
}

- (void)dealloc {
	[deviceImage release];
	[name release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	// Draw the placard at 0, 0
	[deviceImage drawAtPoint:(CGPointMake(200, 0.0))];
	//[name drawRect:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2, 10,100)];
}

@end
