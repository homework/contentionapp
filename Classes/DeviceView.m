
#import "DeviceView.h"


@implementation DeviceView

@synthesize deviceImage;
@synthesize name;
@synthesize namelabel;
@synthesize index;
@synthesize bandwidthbar;
@synthesize touchDelegate;
@synthesize identifier;
@synthesize bigframe;

CGRect imagebounds;
CGRect labelbounds;
float imageindent;

-(id) initWithValues:(NSString*) identity name:(NSString *) nodename position:(int) pos bandwidth: (float) b frame:(CGRect) frame image:(NSString*) img imageindent:(float) i {
	UIImage *image = [UIImage imageNamed:img];
	//self.bigframe = frame;
	imageindent = i;
	//[image drawInRect:CGRectMake(0.0, i, image.size.width, image.size.height)];
	if (self = [self initWithFrame:frame]){
		
		deviceImage = image;
		self.name = nodename;
		self.identifier = identity;
		labelbounds = CGRectMake(15.0, 0.0, 200.0, 20);
		namelabel = [[UILabel alloc ] initWithFrame:labelbounds];
		namelabel.textAlignment =  UITextAlignmentLeft;
		namelabel.textColor = [UIColor blackColor];
		namelabel.backgroundColor = [UIColor clearColor];
		
		self.bandwidthbar = [[PDColoredProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
		self.bandwidthbar.frame = CGRectMake(15.0, (deviceImage.size.height/2) - 7.5, 200.0, 15);
		namelabel.text = nodename;
		[self update:pos bandwidth:b];
		[self addSubview:namelabel];
		[self addSubview:bandwidthbar];
		// Load the display strings
	}
	return self;
	
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	
	
	if (index < 3){
		
		UITouch *touch = [touches anyObject];
		
		CGPoint thePoint = [touch locationInView:self];
		
		if (CGRectContainsPoint (labelbounds,thePoint)){
			[self.touchDelegate touched:LABEL viewname:identifier position:index];
		}else if (CGRectContainsPoint (CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height),thePoint)){	
			[self.touchDelegate touched:IMAGE viewname:identifier position:index];
		}else{
			[self.touchDelegate touched:OTHER viewname:identifier position:index];
		}
	}else{
		[self.touchDelegate touched:IMAGE viewname:identifier position:index];
		//	NSLog(@"INDEX + %d", index);
	//	[super touchesBegan:touches withEvent:event];
	}
}

-(void) updateName:(NSString *) n{
	[self setName:n];
	namelabel.text = n;
	[self setNeedsDisplay];
	
}

-(void) updateImage:(NSString *)image{
	deviceImage = [UIImage imageNamed:image];
	[self setNeedsDisplay];
}


-(void) update:(int)p bandwidth:(float) bandwidth{
	self.index = p;
	
	
	if (p < 3){
		//self.backgroundColor = [UIColor clearColor];
		//self.bounds = CGRectMake(0.0, 0.0, 320, 85);	
		bandwidth = MAX(bandwidth, 0.1); //so that we see something for low bandwidths
		[self.bandwidthbar setProgress:bandwidth];
		if (bandwidth > 0.8){
			[self.bandwidthbar setTintColor:[UIColor redColor]];
		}
		else if (bandwidth > 0.6){
			[self.bandwidthbar setTintColor:[UIColor orangeColor]];
		}
		else{
			[self.bandwidthbar setTintColor:[UIColor greenColor]];
		}
		
		self.bandwidthbar.layer.opacity = 1.0f;
		namelabel.layer.opacity  = 1.0f;
	}else{
		
		namelabel.layer.opacity  = 0.0f;
		self.bandwidthbar.layer.opacity = 0.0f;
		//self.backgroundColor = [UIColor greenColor];
	}
	[self setNeedsDisplay];
}

- (void)dealloc {
	[deviceImage release];
	[name release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	if(index < 3){
		[deviceImage drawAtPoint:(CGPointMake(imageindent, 0.0))];
	}
	else{
		[deviceImage drawAtPoint:(CGPointMake(imageindent -200, 0.0))];
	}
	imagebounds = CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height);
	
		
	/*
	 if (index < 3){
	 CGContextRef context = UIGraphicsGetCurrentContext();
	 CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	 CGContextSetLineWidth(context, 1.0);
	 CGContextMoveToPoint(context, 15.0, deviceImage.size.height/2);
	 CGContextAddLineToPoint(context, 220.0, deviceImage.size.height/2);
	 CGContextStrokePath(context);
	 }*/
}

@end
