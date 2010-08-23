
#import "DeviceView.h"


@implementation DeviceView

@synthesize deviceImage;
@synthesize name;
@synthesize namelabel;
@synthesize index;

CGRect imagebounds;
CGRect labelbounds;
float imageindent;

-(id) initWithValues:(NSString *) nodename position:(int) pos frame:(CGRect) frame imageindent:(float) i{
	UIImage *image = [UIImage imageNamed:@"iphone.png"];
	
	imageindent = i;
		//[image drawInRect:CGRectMake(0.0, i, image.size.width, image.size.height)];
	if (self = [self initWithFrame:frame]){
		
		deviceImage = image;
		self.name = nodename;
		//namelabel = [ [UILabel alloc ] initWithFrame:CGRectMake((self.bounds.size.width / 2) - 200,0.0, 150.0, 43.0) ];
		labelbounds = CGRectMake(15.0, (deviceImage.size.height/2)-30, 150.0, 40);
		namelabel = [[UILabel alloc ] initWithFrame:labelbounds];
		namelabel.textAlignment =  UITextAlignmentLeft;
		namelabel.textColor = [UIColor blackColor];
		namelabel.backgroundColor = [UIColor clearColor];
		//namelabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(16.0)];
		namelabel.text = nodename;
		[self updateMyPosition:pos];
		[self addSubview:namelabel];
		
		// Load the display strings
	}
	return self;
	
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (self.index >= 3){
		NSLog(@"retunring - position > 3");
		return;
	}
	
	UITouch *touch = [touches anyObject];
	
	// Only move the placard view if the touch was in the placard view
	CGPoint thePoint = [touch locationInView:self];
	
	if (CGRectContainsPoint (labelbounds,thePoint)){
		NSLog(@"label touched!!");
		[super.superview.superview respondToLabelTouch:name];
	}else if (CGRectContainsPoint (CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height),thePoint)){	
		NSLog(@"image touched");
	}else{
		NSLog(@"something else touched");
	}
	
	//[super touchesBegan:touches withEvent:event];
}

-(void) updateMyPosition:(int)p{
	self.index = p;
	
	
	if (p < 3){
		namelabel.layer.opacity  = 1.0f;
	}else{
		namelabel.layer.opacity  = 0.0f;
	}
	[self setNeedsDisplay];
}

- (void)dealloc {
	[deviceImage release];
	[name release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	[deviceImage drawAtPoint:(CGPointMake(imageindent, 0.0))];
	imagebounds = CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height);
	
	
	if (index < 3){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
		CGContextSetLineWidth(context, 1.0);
		CGContextMoveToPoint(context, 15.0, deviceImage.size.height/2);
		CGContextAddLineToPoint(context, 220.0, deviceImage.size.height/2);
		CGContextStrokePath(context);
	}
}

@end
