//
//  DevicesTextInputView.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DevicesTextInputView.h"


@interface DevicesTextInputView(private)
-(void) drawGridlines:(CGContextRef) context x: (float) x width: (float) width;
@end

@implementation DevicesTextInputView

@synthesize name;
@synthesize deviceImage;
@synthesize index;

float imageindent;
CGRect imagebounds;




-(id) initWithValues:(NSString *) viewname position:(int) pos  image: (NSString*) img imageindent:(float) i frame:(CGRect) frame{
	
	if ((self = [super initWithFrame:frame])) {
		self.index = pos;
		NSLog(@"--->set index to %d", self.index);
		UIImage *image = [UIImage imageNamed:@"iphone.png"];//[UIImage imageNamed:image];
		imageindent = i;
		deviceImage = image;
		self.name = viewname;
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
    }
    return self;
}


-(void) updateMyPosition:(int)p {
	self.index = p;
	NSLog(@"gridlines set position to %d", p);
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	NSLog(@"drawing rect...");
	[deviceImage drawAtPoint:(CGPointMake(imageindent, 0.0))];
	imagebounds = CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawGridlines:context x:0.0f width: 200.0f];
	[self updateValues];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (self.index >= 3)
		return;
	
	UITouch *touch = [touches anyObject];
	CGPoint thePoint = [touch locationInView:self];
	//NSLog(@"the point x = %f, y = %f", thePoint.x, thePoint.y);
	
	if (CGRectContainsPoint (CGRectMake(0.0,0.0, 200.0, deviceImage.size.height),thePoint)){
		[super.superview.superview respondToGridTouch:name];
	}else if (CGRectContainsPoint (CGRectMake(imageindent, 0.0, deviceImage.size.width, deviceImage.size.height),thePoint)){	
	//	NSLog(@"image touched");
	}else{
	//	NSLog(@"something else touched");
	}

}


-(void) updateValues{
	
}

-(void) drawGridlines:(CGContextRef) context x: (float) x width: (float) w
{
	
	if (self.index < 3){
		NSLog(@"drawing grid lines...");
		CGContextSetLineWidth(context, 1.0);
		CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
		
		for(CGFloat y = 0.0 ; y <=  deviceImage.size.height; y += 15)
		{
			CGContextMoveToPoint(context, 15.0, y);
			CGContextAddLineToPoint(context, (x + w), y);
			CGContextStrokePath(context);
		}
	}
	
}


- (void)dealloc {
    [super dealloc];
}


@end
