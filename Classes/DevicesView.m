//
//  ApplicationView.m
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DevicesView.h"

@interface DevicesView(private)

-(int) findLayerIndex:(NSString *) layername;
-(CGPoint) getCoordinates:(int) position;
-(void) addNewLayer:(NodeTuple *) node position:(int) pos;
-(void) createLayers;
-(void) createTopLayer:(NodeTuple*)node position: (int) pos;
-(void) createBottomLayer:(NodeTuple*)node position: (int) pos;
@end


@implementation DevicesView

@synthesize delegate;
@synthesize nodes;


- (id)initWithFrame:(CGRect)frame nodes:(NSMutableArray *) n{
    if ((self = [super initWithFrame:frame])) {
		/*[[self layer] setDelegate:self];
		self.nodes = n;
		
		[self createLayers];
		self.backgroundColor = [UIColor whiteColor];
		[[self layer] setNeedsDisplay];  */
		[self createViews];
	}
    return self;
}

-(BOOL) containsLayer:(NSString*) name inarray:(NSMutableArray *)n{
	NSEnumerator *enumerator = [n objectEnumerator];
	NodeTuple* node;
	int count = 0;
	while ( node = [enumerator nextObject]  /*&& (count++ < DEVICES) */) {
		if (count++ >= DEVICES)
			break;
		if ([name isEqualToString:[node name]])
			return YES;
	}
	return NO;
}

-(BOOL) containsView:(NSString*) name inarray:(NSMutableArray *)n{
	NSEnumerator *enumerator = [n objectEnumerator];
	NodeTuple* node;
	int count = 0;
	while ( node = [enumerator nextObject]  /*&& (count++ < DEVICES) */) {
		if (count++ >= DEVICES)
			break;
		if ([name isEqualToString:[node name]])
			return YES;
	}
	return NO;
}

-(float) getScale:(int) value{
	//return 0.7f;
	return MIN(1.0f, MAX (0.4f, ((float) value) / 50000)); 
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



-(void) update:(NSMutableArray *) n{
	
	NSLog(@"DEVICE VIEW GOT UPDATE %d", [n count]);
	NSEnumerator *enumerator = [n objectEnumerator];
    NodeTuple* node;
	
	//remove old views here..
	
	for (int i = 0; i < DEVICES; i++){
		if (myviews[i] != NULL){
			DeviceView *current = (DeviceView*) myviews[i]; 
			
			if (![self containsView:current.name inarray:n]){
					NSLog(@"removed view %@", current.name);
					[current removeFromSuperview];
					myviews[i] = NULL;
			}
		}
	}
	
	
	
	//NSValue *touchPointValue = [[NSValue valueWithCGPoint:touchPoint] retain];
	
	
	
	int position = 0;
	
	while ( node = [enumerator nextObject]) {
		

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:2.0];
		[UIView setAnimationDelegate:self];
		if (position >= DEVICES)
			break;
		int index = [self findViewIndex:[node name]];
		
		if (index == -1){
			NSLog(@"Adding new view");
			[self addNewView:node position:position];
			index = [self findViewIndex:[node name]];
		}
		
	    if (index == -1){
			NSLog(@"INDEX IS -1");
		}
		myviews[index].center = [self getCoordinates:position];
		[myviews[index] updateMyPosition:position];
		
		CGAffineTransform transform;
		if (position < 3){
			 transform = CGAffineTransformMakeScale(1.0, 1.0);
			myviews[index].namelabel.layer.opacity  = 1.0;
		}
		else{
			transform = CGAffineTransformMakeScale(0.5, 0.5);
			myviews[index].namelabel.layer.opacity  = 0.0;
		}
		myviews[index].transform = transform;
		[UIView commitAnimations];
		
		position++;
		
				
	}
	
	
	
	
	
	//[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	//CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	//pview1.transform = transform;
	//pview2.transform = transform;
	


}

-(void) updateold:(NSMutableArray *)n{
	
	
	
	/*
	NSEnumerator *enumerator = [n objectEnumerator];
    NodeTuple* node;
	
	for (int i = 0; i < DEVICES; i++){
		if (mylayers[i] != NULL){
			CALayer *current = (CALayer*) mylayers[i]; 
			current = current.modelLayer;
			
			if (![self containsLayer:current.name inarray:n]){
				[current removeFromSuperlayer];
				CALayer *title = (CALayer*) mytitlelayers[i];
				[title removeFromSuperlayer];
				mylayers[i] = NULL;
				mytitlelayers[i] = NULL;
				
			}
		}
	}
	enumerator = [n objectEnumerator];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0f] forKey:kCATransactionAnimationDuration];
	
	
	int position = 0;
	
	while ( node = [enumerator nextObject]) {
		
		if (position >= DEVICES)
			break;
		
		int index = [self findLayerIndex:[node name]];
		
		
		if (index == -1){
			[self addNewLayer:node position:position];
			index = [self findLayerIndex:[node name]];
			
		}
		
		mylayers[index].position	  =  mytitlelayers[index].position = [self getCoordinates:position];
		
		CGFloat factor = 1.0f;
		
		if (position < 3){
			CATransform3D transform = CATransform3DMakeScale(factor, factor, 1.0f);
			mylayers[index].transform = transform;
			mytitlelayers[index].opacity = 1.0f;
		}else{
			CATransform3D transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
			mylayers[index].transform = transform;	
			mytitlelayers[index].opacity = 0.0f;
		}
		
		position++;
		
	}
	
	[CATransaction commit];
*/
}



-(int) findViewIndex:(NSString *) viewname{
	for (int i = 0; i < DEVICES; i++){
		
		
		DeviceView *current = (DeviceView *) myviews[i]; 
		if (current != NULL){
			if (current.name != nil){
				if ([current.name isEqualToString:viewname])
					return i;

			}
		}
	}
	return -1;
}


-(int) findLayerIndex:(NSString *) layername{
	
	for (int i = 0; i < DEVICES; i++){
		
		
		CALayer *current = (CALayer*) mylayers[i]; 
		if (current != NULL){
			current = current.modelLayer;
			
			if (current.name != nil){
				if ([current.name isEqualToString:layername])
					return i;
			}
		}
	}
	return -1;
}

-(CGPoint) getCoordinates:(int) position{
	int spacer = 80;
	
	if (position < 3){
		return CGPointMake(180, (80 + (position)*100));
	}else{
		return CGPointMake(40 + (spacer) * (position-3),330);
	}
}


-(void) addNewView:(NodeTuple *) node position:(int) pos{
	[self createTopView:node position: pos];
}

-(void) addNewLayer:(NodeTuple *) node position:(int) pos{
	
	if (pos < 3){
		[self createTopLayer:node position: pos];
	}else{
		[self createBottomLayer:node position: pos];
	}
}


-(void) createViews{
	
	
	NSEnumerator *enumerator = [nodes objectEnumerator];
    NodeTuple* node;
	int count = 0;
    
	while ( (node = [enumerator nextObject])) {
		if (count >= DEVICES)
			break;
		
		//if (count < 3){
			
			[self createTopView:node position: count];
		//}else{
		//	[self createBottomView:node position: count];
		//}
		count +=1;
	}
	
}

-(void) createTopView:(NodeTuple*)node position: (int) pos{
	
	DeviceView *pview = [[[DeviceView alloc] initWithValues:[node name] position:pos] retain];
	pview.center = [self getCoordinates:pos];
	[self addSubview:pview];
	
	BOOL space = false;
	
	for (int i = 0; i < DEVICES; i++){
		if (myviews[i] == NULL){
			myviews[i] = pview;
			space = true;
			break;
		}
	}
	if (!space){
		NSLog(@"run out of space!!");
	}
}

-(void) createBottomView:(NodeTuple*)node position: (int) pos{
	
}





-(void) createLayers{
	
	/*
	 *initialize the layer array
	 */
	
	NSEnumerator *enumerator = [nodes objectEnumerator];
    NodeTuple* node;
	int count = 0;
    
	while ( (node = [enumerator nextObject])) {
		if (count >= DEVICES)
			break;
		
		if (count < 3){
			
			[self createTopLayer:node position: count];
		}else{
			[self createBottomLayer:node position: count];
		}
		count +=1;
	}
}

-(void) createTopLayer:(NodeTuple*)node position: (int) pos{
	
	// Create the lines and font layer
	
	CAShapeLayer *titlelayer = [CAShapeLayer layer];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake(-30,0, -200,-1));
	titlelayer.path = path;
	titlelayer.fillColor = [UIColor darkGrayColor].CGColor;
	titlelayer.position = [self getCoordinates:pos];//CGPointMake(250, (50 + (pos-1)*100));
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 20)];
	label.text = [node name];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.layer.position = CGPointMake(-130,-15);
	[titlelayer addSublayer: label.layer];
	[[self layer] addSublayer: titlelayer];
	
	
	//Create the circles and images layers
	
	CAShapeLayer* appLayer = [CAShapeLayer layer];
	path = CGPathCreateMutable();
	CGPathAddArc(path, NULL, 0, 0, 20, 0, 2 * M_PI, true);
	appLayer.path = path;
	appLayer.fillColor = [UIColor darkGrayColor].CGColor;// [UIColor colorWithRed:(float) arc4random() / ARC4RANDOM_MAX green:(float) arc4random() / ARC4RANDOM_MAX blue:(float) arc4random() / ARC4RANDOM_MAX alpha:1].CGColor; 
	appLayer.fillRule = kCAFillRuleNonZero;
	appLayer.position = [self getCoordinates:pos];//CGPointMake(250,50 + (pos-1)*100);
	[[self layer] addSublayer: appLayer];
	UIImage* image = [UIImage imageNamed: [node image]]; 
	
	if (image == nil){
		image = [UIImage imageNamed: @"unknown.png"];
	}
	
	CGFloat	nativeWidth = CGImageGetWidth(image.CGImage);
	CGFloat nativeHeight = CGImageGetHeight(image.CGImage);
	CGRect  startFrame = CGRectMake(0.0, 0.0, nativeWidth, nativeHeight);
	CALayer *imageLayer = [CALayer layer];
	imageLayer.contents = (id)image.CGImage;
	imageLayer.frame = startFrame;
	imageLayer.position = CGPointMake(0,0);
	[appLayer addSublayer:imageLayer];
	
	appLayer.name =[node name];
	
	/*
	 * stuff new layer in empty slot
	 */ 
	
	
	for (int i = 0; i < DEVICES; i++){
		if (mylayers[i] == NULL){
			mylayers[i] = appLayer;
			mytitlelayers[i] = titlelayer;
			break;
		}
	}
}

-(void) createBottomLayer:(NodeTuple*)node position: (int) pos{
	
	CAShapeLayer *titlelayer = [CAShapeLayer layer];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake(-30,0, -200,-1));
	titlelayer.path = path;
	titlelayer.fillColor = [UIColor darkGrayColor].CGColor;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
	label.text = [node name];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.layer.position = CGPointMake(-160,-15);
	[titlelayer addSublayer: label.layer];
	
	titlelayer.position = [self getCoordinates:pos];
	titlelayer.opacity = 0.0f;
	[[self layer] addSublayer: titlelayer];
	
	UIImage*    image = [UIImage imageNamed: [node image]];
	
	if (image == nil){
		image = [UIImage imageNamed: @"unknown.png"];
	}
	CGFloat nativeWidth = CGImageGetWidth(image.CGImage);
	CGFloat nativeHeight = CGImageGetHeight(image.CGImage);
	CGRect startFrame = CGRectMake(0.0, 0.0, nativeWidth, nativeHeight);
	CALayer *imageLayer = [CALayer layer];
	imageLayer.contents = (id)image.CGImage;
	imageLayer.frame = startFrame;
	imageLayer.position = [self getCoordinates:pos];// CGPointMake(40 + (spacer) * (pos-4),330);
	imageLayer.name = [node name];
	[self.layer addSublayer:imageLayer];
	imageLayer.transform = CATransform3DMakeScale( 0.5f, 0.5f, 1.0f );
	
	for (int i = 0; i < DEVICES; i++){
		if (mylayers[i] == NULL){
			mylayers[i] = imageLayer;
			mytitlelayers[i] = titlelayer;
			break;
		}
	}
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
	[super drawLayer:layer inContext:ctx];
	
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	
	
	
	/*UITouch *touch = [touches anyObject];
	CGPoint thePoint = [touch locationInView:self];
	int position = thePoint.y / (360 / 4);
	position += (position >= 3) ? (thePoint.x / (310/4)) : 0;
	NSLog(@"y = %f x = %f position = %d", thePoint.y, thePoint.x, position);*/
}
						
						/*
	NSLog(@"TOUCHED!!!");
	UITouch *touch = [touches anyObject];
	CGPoint thePoint = [touch locationInView:self];
	thePoint = [self.layer convertPoint:thePoint toLayer:self.layer];
	CALayer *theLayer = [self.layer hitTest:thePoint];
	
	NSLog(@"%@ was touched", [theLayer name]);
	for (int i = 0; i < DEVICES; i++){
		if (mylayers[i] != NULL){
			if ( [mylayers[i] containsPoint:point]){
				NSLog(@"touched %@", [mylayers[i] name]);
			}
		}
		if (mytitlelayers[i] != NULL){
			if ( [mytitlelayers[i] containsPoint:point]){
				NSLog(@"touched %@", [mytitlelayers[i] name]);
			}
		}
	}
	
	CALayer *layer = [(CALayer *)self.layer.presentationLayer hitTest:point];
	layer = layer.modelLayer; 
	layer.opacity = 0.5;
}*/

- (void)dealloc {
    [super dealloc];
}


@end
