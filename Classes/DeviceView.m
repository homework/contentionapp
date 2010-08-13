//
//  DeviceView.m
//  ContentionApp
//
//  Created by Tom Lodge on 07/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceView.h"


@implementation DeviceView
@synthesize devicea;
@synthesize deviceb;
@synthesize devicec;
@synthesize deviceatitle;
@synthesize devicebtitle;
@synthesize devicectitle;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		NSLog(@"initing view with frame...");
		[[self layer] setDelegate:self];
		[self createLayers];
		self.backgroundColor = [UIColor whiteColor];
		
		[[self layer] setNeedsDisplay];  
		[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animateLayers) userInfo:nil repeats:YES]; 
    }
    return self;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([self delegate] == nil)
		return;
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	

	CAShapeLayer *layer = [(CAShapeLayer *)self.layer.presentationLayer hitTest:touchPoint];
	//[self setValue:layer forKey:@"touched"];
	if (layer != nil){
		//NSLog( [NSString stringWithFormat:@"great something was touched"]);
		
		layer = layer.modelLayer;
		
		if (layer.name != nil){
			NSLog([NSString stringWithFormat:@"layer is %@", layer.name]);
			[[self delegate] touched:layer.name];
		}
		
		/*else{
			for(CALayer *currentlayer in layer.sublayers)
			{
				NSLog([NSString stringWithFormat:@"layer is %@", currentlayer.name]);
			}
		}*/
		
		
		//layer.opacity = 0.5;
	}
	[super touchesBegan:touches withEvent:event];
}


-(void) animateLayers{	
	
	CGPoint p1 = devicea.position;
	CGPoint p2 = deviceb.position;
	CGPoint p3 = devicec.position;
	
	[CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:3.0f] forKey:kCATransactionAnimationDuration];
    CGFloat factor = rand()/(CGFloat)RAND_MAX * 3.0f;
    CATransform3D transform = CATransform3DMakeScale(factor, factor, 1.0f);
    /*transform = CATransform3DRotate(transform, acos(-1.0f)*rand()/(CGFloat)RAND_MAX, 
	 rand()/(CGFloat)RAND_MAX, rand()/(CGFloat)RAND_MAX, rand()/(CGFloat)RAND_MAX);*/
    devicea.transform = transform;
    devicea.position = p3;
	deviceatitle.position = p3;
	[CATransaction commit];
	
	
	[CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:3.0f] forKey:kCATransactionAnimationDuration];
	factor = rand()/(CGFloat)RAND_MAX * 3.0f;
    //CATransform3D 
	transform = CATransform3DMakeScale(factor, factor, 1.0f);
    //transform = CATransform3DRotate(transform, acos(-1.0f)*rand()/(CGFloat)RAND_MAX, 
	//rand()/(CGFloat)RAND_MAX, rand()/(CGFloat)RAND_MAX, rand()/(CGFloat)RAND_MAX);
    deviceb.transform = transform;
    deviceb.position = p1;
	devicebtitle.position = p1;
	[CATransaction commit];
	
	
	[CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:3.0f] forKey:kCATransactionAnimationDuration];
	factor = rand()/(CGFloat)RAND_MAX * 3.0f;
    //CATransform3D 
	transform = CATransform3DMakeScale(factor, factor, 1.0f);
    //transform = CATransform3DRotate(transform, acos(-1.0f)*rand()/(CGFloat)RAND_MAX, 
	//rand()/(CGFloat)RAND_MAX, rand()/(CGFloat)RAND_MAX, rand()/(CGFloat)RAND_MAX);
    devicec.transform = transform;
    devicec.position = p2;
	devicectitle.position = p2;
	[CATransaction commit];
	/*NSLog(@"in here...");
	 CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
	 // Configure animation
	 anim.fromValue      = [NSValue valueWithPoint:devicea.position];
	 anim.toValue        = [NSValue valueWithPoint:deviceb.position];
	 anim.timingFunction = [CAMediaTimingFunction
	 functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	 anim.fillMode  = kCAFillModeForwards;
	 anim.duration		= 2.0;
	 anim.removedOnCompletion = NO;
	 [devicea addAnimation:anim forKey:@"position"];  */
	
}

-(void) createLayers{
	
	//[self layer].name = @"root layer";
	/*
	 * Generate the lines and titles with fonts.
	 */
	
	self.deviceatitle = [CAShapeLayer layer];
	CGMutablePathRef path5 = CGPathCreateMutable();
	CGPathAddRect(path5, NULL, CGRectMake(0,0, -230,-2));
	self.deviceatitle.path = path5;
	self.deviceatitle.fillColor = [UIColor greenColor].CGColor;
	//self.deviceatitle.fillRule = kCAFillRuleNonZero;
	self.deviceatitle.position = CGPointMake(250,70);
	[[self layer] addSublayer: self.deviceatitle];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
	label.text = @"Tom's Mac Air";
	//label.font = [UIFont  boldSystemFontOfSize:30];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.layer.position = CGPointMake(-160,-15);
	[[self deviceatitle] addSublayer: label.layer];

	
	self.devicebtitle = [CAShapeLayer layer];
	CGMutablePathRef path6 = CGPathCreateMutable();
	CGPathAddRect(path6, NULL, CGRectMake(0,0, -230,-2));
	self.devicebtitle.path = path6;
	self.devicebtitle.fillColor = [UIColor redColor].CGColor;
	//self.deviceatitle.fillRule = kCAFillRuleNonZero;
	self.devicebtitle.position = CGPointMake(250,170);
	[[self layer] addSublayer: self.devicebtitle];
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
	label2.text = @"Katie's Laptop";
	//label.font = [UIFont  boldSystemFontOfSize:30];
	label2.textColor = [UIColor blackColor];
	label2.backgroundColor = [UIColor clearColor];
	label2.layer.position = CGPointMake(-160,-15);
	[[self devicebtitle] addSublayer: label2.layer];
	
	self.devicectitle = [CAShapeLayer layer];
	CGMutablePathRef path7 = CGPathCreateMutable();
	CGPathAddRect(path7, NULL, CGRectMake(0,0, -230,-2));
	self.devicectitle.path = path7;
	self.devicectitle.fillColor = [UIColor blueColor].CGColor;
	//self.deviceatitle.fillRule = kCAFillRuleNonZero;
	self.devicectitle.position = CGPointMake(250,270);
	[[self layer] addSublayer: self.devicectitle];
	
	UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
	label3.text = @"Katie's iPhone";
	//label.font = [UIFont  boldSystemFontOfSize:30];
	label3.textColor = [UIColor blackColor];
	label3.backgroundColor = [UIColor clearColor];
	label3.layer.position = CGPointMake(-160,-15);
	[[self devicectitle] addSublayer: label3.layer];
	//NSMutableArray* layers = [NSArray arrayWithObjects:self.devicea,self.deviceb,self.devicec,nil];
	
	
		
	//for (int i=0; i < 3; i++){
	
	//CAShapeLayer *l = (CAShapeLayer*) [layers objectAtIndex:i];
	
	/*
	 * Generate the main circles + images
	 */
	self.devicea = [CAShapeLayer layer];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddArc(path, NULL, 0, 0, 20, 0, 2 * M_PI, true);
	self.devicea.path = path;
	self.devicea.fillColor = [UIColor greenColor].CGColor;// [UIColor colorWithRed:(float) arc4random() / ARC4RANDOM_MAX green:(float) arc4random() / ARC4RANDOM_MAX blue:(float) arc4random() / ARC4RANDOM_MAX alpha:1].CGColor; 
	self.devicea.fillRule = kCAFillRuleNonZero;
	self.devicea.position = CGPointMake(250,80);
	[[self layer] addSublayer: self.devicea];
	
	
	UIImage*    image1 = [UIImage imageNamed:@"laptop.png"];
	CGFloat nativeWidth = CGImageGetWidth(image1.CGImage);
	CGFloat nativeHeight = CGImageGetHeight(image1.CGImage);
	CGRect      startFrame = CGRectMake(0.0, 0.0, nativeWidth, nativeHeight);
	CALayer *imageLayer1 = [CALayer layer];
	imageLayer1.contents = (id)image1.CGImage;
	imageLayer1.frame = startFrame;
	imageLayer1.position = CGPointMake(0,0);
	imageLayer1.name = @"Tom's Mac air";
	[self.devicea addSublayer:imageLayer1];
	
	self.deviceb = [CAShapeLayer layer];
	CGMutablePathRef path2 = CGPathCreateMutable();
	CGPathAddArc(path2, NULL, 0, 0, 20, 0, 2 * M_PI, true);
	self.deviceb.path = path2;
	self.deviceb.fillColor = [UIColor redColor].CGColor;// [UIColor colorWithRed:(float) arc4random() / ARC4RANDOM_MAX green:(float) arc4random() / ARC4RANDOM_MAX blue:(float) arc4random() / ARC4RANDOM_MAX alpha:1].CGColor; 
	self.deviceb.fillRule = kCAFillRuleNonZero;
	self.deviceb.position = CGPointMake(250,180);
	[[self layer] addSublayer: self.deviceb];
	UIImage*    image2 = [UIImage imageNamed:@"iphone.png"];
	 nativeWidth = CGImageGetWidth(image2.CGImage);
	 nativeHeight = CGImageGetHeight(image2.CGImage);
	      startFrame = CGRectMake(0.0, 0.0, nativeWidth, nativeHeight);
	CALayer *imageLayer2 = [CALayer layer];
	imageLayer2.contents = (id)image2.CGImage;
	imageLayer2.frame = startFrame;
	imageLayer2.position = CGPointMake(0,0);
	imageLayer2.name = @"Katie's Laptop";
	[self.deviceb addSublayer:imageLayer2];
	
	
	
	self.devicec = [CAShapeLayer layer];
	CGMutablePathRef path3 = CGPathCreateMutable();
	CGPathAddArc(path3, NULL, 0, 0, 20, 0, 2 * M_PI, true);
	self.devicec.path = path3;
	self.devicec.fillColor = [UIColor blueColor].CGColor;// [UIColor colorWithRed:(float) arc4random() / ARC4RANDOM_MAX green:(float) arc4random() / ARC4RANDOM_MAX blue:(float) arc4random() / ARC4RANDOM_MAX alpha:1].CGColor; 
	self.devicec.fillRule = kCAFillRuleNonZero;
	self.devicec.position = CGPointMake(250,280);
	[[self layer] addSublayer: self.devicec];
	UIImage*    image3 = [UIImage imageNamed:@"pc.png"];
	 nativeWidth = CGImageGetWidth(image3.CGImage);
	 nativeHeight = CGImageGetHeight(image3.CGImage);
	      startFrame = CGRectMake(0.0, 0.0, nativeWidth, nativeHeight);
	CALayer *imageLayer3 = [CALayer layer];
	imageLayer3.contents = (id)image3.CGImage;
	imageLayer3.frame = startFrame;
	imageLayer3.position = CGPointMake(0,0);
	imageLayer3.name =@"Katie's iphone";

	[self.devicec addSublayer:imageLayer3];
	
}


-(void) createLayer: (float) x  ypos:(float) y radius:(float) r{
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
	[super drawLayer:layer inContext:ctx];
	
}

/*	NSLog(@"great - got to draw layer......");
 int radius = ([self frame].size.width/2) - 20;
 float originx = [self frame].size.width/2;
 float originy = [self frame].size.height;
 
 
 CGContextSetLineWidth(ctx,1);
 CGContextSetRGBFillColor(ctx, 1,0,0,1);
 
 CGContextBeginPath(ctx);
 float lastpoint = M_PI;
 int total = 100;
 CGContextMoveToPoint(ctx, originx, originy);
 CGContextAddLineToPoint(ctx, originx - radius , originy);
 
 for (int i = 0; i < 10; i++){
 float multiplier = ((float) 10 / total);
 float topoint = lastpoint + (multiplier *  M_PI);
 CGContextMoveToPoint(ctx, originx, originy);
 CGContextAddArc(ctx,originx,originy, radius,  lastpoint, topoint, false);
 CGContextClosePath(ctx);
 UIColor *color = [UIColor redColor];
 //UIColor *clr = [colours objectAtIndex:i];
 
 CGFloat *clr = CGColorGetComponents(color.CGColor);
 //NSLog(@"color = %@", [colours objectAtIndex:i]);
 CGContextSetRGBFillColor(ctx, clr[0], clr[1], clr[2], 1);
 
 //CGContextSetRGBFillColor(context, (float) arc4random() / ARC4RANDOM_MAX, 
 // (float) arc4random() / ARC4RANDOM_MAX,
 // (float) arc4random() / ARC4RANDOM_MAX, 1);*/

//CGContextFillPath(ctx);
//lastpoint = topoint;
//}


//CGContextRestoreGState(ctx);
//NSLog(@"am here layer!!!");	
//}*/

- (void)dealloc {
    [super dealloc];
}


@end
