//
//  ApplicationView.m
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationView.h"

@interface ApplicationView(private)

-(int) findLayerIndex:(NSString *) layername;
-(CGPoint) getCoordinates:(int) position;
-(void) addNewLayer:(NodeTuple *) node position:(int) pos;
-(void) createLayers;
-(void) createTopLayer:(NodeTuple*)node position: (int) pos;
-(void) createBottomLayer:(NodeTuple*)node position: (int) pos;
@end


@implementation ApplicationView

@synthesize delegate;
@synthesize nodes;
//@synthesize layers;



- (id)initWithFrame:(CGRect)frame nodes:(NSMutableArray *) n{
    if ((self = [super initWithFrame:frame])) {
		[[self layer] setDelegate:self];
		self.nodes = n;
		
		[self createLayers];
		self.backgroundColor = [UIColor whiteColor];
		[[self layer] setNeedsDisplay];  
		
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
-(void) update:(NSMutableArray *)n{
	
	NSEnumerator *enumerator = [n objectEnumerator];
    NodeTuple* node;
	
	
	
	for (int i = 0; i < DEVICES; i++){
		if (mylayers[i] != NULL){
			CALayer *current = (CALayer*) mylayers[i]; 
			current = current.modelLayer;
			
			if (![self containsLayer:current.name inarray:n]){
				NSLog(@"deleting layer %@", current.name);
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
		
		//if (node == NULL)
		//	break;
		
		
		int index = [self findLayerIndex:[node name]];
		
		
		if (index == -1){
			[self addNewLayer:node position:position];
			NSLog(@"*new* node %@ pos %d", [node name], position); 
			index = [self findLayerIndex:[node name]];
			
		}else{
			NSLog(@"*old* node %@ pos %d", [node name], position); 	
		}
		
		mylayers[index].position	  =  mytitlelayers[index].position = [self getCoordinates:position];
		
		
		//NSLog(@"node=%@ pos=%d", [node name], position);
		
		//NSLog(@"node=%@ pos=%d x=%f y=%f", [node name], position, pps.x, pps.y);
		
		CGFloat factor = 1.0f;//[self getScale:[node value]];// 0.4f + ((random()/(CGFloat)RAND_MAX) * 0.6f);
		
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
		return CGPointMake(250, (50 + (position)*100));
	}else{
		return CGPointMake(40 + (spacer) * (position-3),330);
	}
}



-(void) addNewLayer:(NodeTuple *) node position:(int) pos{
	
	if (pos < 3){
		[self createTopLayer:node position: pos];
	}else{
		[self createBottomLayer:node position: pos];
	}
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
	//imageLayer.name = [node name];
	//float scale = [self getScale:[node value]];
	//imageLayer.transform = CATransform3DMakeScale( scale, scale, 1.0 );
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

-(void) createLayer: (float) x  ypos:(float) y radius:(float) r{
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
	[super drawLayer:layer inContext:ctx];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
