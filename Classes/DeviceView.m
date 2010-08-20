
#import "DeviceView.h"


@implementation DeviceView

@synthesize deviceImage;
@synthesize name;
@synthesize namelabel;

CGRect imagebounds;
CGRect labelbounds;
int imageindent;

-(id) initWithValues:(NSString *) nodename position:(int) position frame:(CGRect) frame imageindent:(float) i{
	UIImage *image = [UIImage imageNamed:@"skype.png"];
	
	imageindent = i;
		//[image drawInRect:CGRectMake(0.0, i, image.size.width, image.size.height)];
	if (self = [self initWithFrame:frame]){
		
		deviceImage = image;
		self.name = nodename;
		//namelabel = [ [UILabel alloc ] initWithFrame:CGRectMake((self.bounds.size.width / 2) - 200,0.0, 150.0, 43.0) ];
		labelbounds = CGRectMake(0.0,43.0/2, 150.0, 43.0);
		namelabel = [ [UILabel alloc ] initWithFrame:labelbounds];
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
	NSLog(@"LOWEst VIEW TOUCHED");
	NSLog(@"the point x = %f, y = %f", thePoint.x, thePoint.y);
	
	if (CGRectContainsPoint (CGRectMake(0.0,43.0/2, 150.0, 43.0),thePoint)){
		NSLog(@"label touched");
		[super.superview.superview respondToLabelTouch:name];
	}else if (CGRectContainsPoint (CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height),thePoint)){	
		NSLog(@"image touched");
	}else{
		NSLog(@"something else touched");
	}
	
	//[super touchesBegan:touches withEvent:event];
}

-(void) updateMyPosition:(int)p{
	position = p;
	
	
	if (p < 3){
		namelabel.layer.opacity  = 1.0f;
		position = p;
	}else{
		namelabel.layer.opacity  = 0.0f;
		//namelabel.opaque = NO;
		//namelabel.layer.opacity  0.0;

	}
}

- (void)dealloc {
	[deviceImage release];
	[name release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	// Draw the placard at 0, 0
	[deviceImage drawAtPoint:(CGPointMake(imageindent, 0.0))];
	imagebounds = CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height);
	//[name drawRect:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2, 10,100)];
}

@end
