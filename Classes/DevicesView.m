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

const static float	IMAGEINDENT = 215;
const static float	VIEWHEIGHT  = 85;

@implementation DevicesView

@synthesize delegate;
@synthesize nodes;


- (id)initWithFrame:(CGRect)frame nodes:(NSMutableArray *) n{
    if ((self = [super initWithFrame:frame])) {
		[self createViews];
	}
    return self;
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

	NSEnumerator *enumerator = [n objectEnumerator];
    NodeTuple* node;
	
	//remove old views here..
	
	for (int i = 0; i < DEVICES; i++){
		if (myviews[i] != NULL){
			DeviceView *current = (DeviceView*) myviews[i]; 
			
			if (![self containsView:current.name inarray:n]){
				UIView *container = [current superview];
				[current removeFromSuperview];
				[container removeFromSuperview];
				myviews[i] = NULL;
			}
		}
	}
	
	int position = 0;
	
	while ( node = [enumerator nextObject]) {
		

		
		if (position >= DEVICES)
			break;
		int index = [self findViewIndex:[node name]];
		
		if (index == -1){
	
			[self addNewView:node position:position];
			index = [self findViewIndex:[node name]];
		}
		
	    if (index == -1){
			NSLog(@"INDEX IS -1");
		}
		
		CGPoint newPosition = [self getCoordinates:position];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:2.0];
		[UIView setAnimationDelegate:self];
		myviews[index].superview.center = newPosition;
		[myviews[index] updateMyPosition:position];
		
		CGAffineTransform transform;
		if (position < 3){
			transform = CGAffineTransformMakeScale(1.0, 1.0);
		}
		else{
			transform = CGAffineTransformMakeScale(0.5, 0.5);
		}
		myviews[index].transform = transform;
		[UIView commitAnimations];
		
		position++;
		
				
	}
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

-(CGPoint) getCoordinates:(int) position{
	int spacer = 80;
	int INDENT = 15;
	if (position < 3){
		return CGPointMake(self.bounds.size.width/2,  (10 + (position)*100) + VIEWHEIGHT/2);
	}else{
		return CGPointMake( (INDENT + (self.bounds.size.width/4 + (spacer * (position-3)))- (IMAGEINDENT/2)), 330);
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
	
	CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, VIEWHEIGHT); 
	ContainerView *container = [[[ContainerView alloc] initWithFrame:frame] retain];
	DeviceView *pview = [[[DeviceView alloc] initWithValues:[node name] position:pos frame:frame imageindent:IMAGEINDENT] retain];
	[pview setBackgroundColor:[UIColor clearColor]];
	[container setBackgroundColor:[UIColor clearColor]];
	container.center = [self getCoordinates:pos];
	[container addSubview:pview];
	
	[self addSubview:container];
	
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


-(void) respondToGridTouch:(NSString *) viewname{
	int index = [self findViewIndex: viewname];
	CGPoint position = CGPointMake(myviews[index].center.x, myviews[index].center.y); 
	CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, VIEWHEIGHT); 
	DeviceView *pview = [[[DeviceView alloc] initWithValues:viewname position:index frame:frame imageindent:IMAGEINDENT] retain];
	[pview setBackgroundColor:[UIColor clearColor]];
	pview.center = position;
	[self animateFlip:pview index:index];
}

-(void) respondToLabelTouch:(NSString *) viewname{
	int index = [self findViewIndex: viewname];
	CGPoint position = CGPointMake(myviews[index].center.x, myviews[index].center.y); 
	CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, VIEWHEIGHT); 
	DevicesTextInputView *pview = [[[DevicesTextInputView alloc] initWithValues:viewname position:index image:@"iphone.png" imageindent:IMAGEINDENT frame:frame] retain];
	[pview setBackgroundColor:[UIColor clearColor]];
	pview.center = position;
	[self animateFlip:pview index:index];
}

-(void) animateFlip: (UIView *)toview index:(int) index{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:myviews[index].superview cache:YES];
    [UIView setAnimationDuration:0.75];
	UIView *container = myviews[index].superview;
	
	[myviews[index] removeFromSuperview];
	[myviews[index] release];
	[container addSubview:toview];
	myviews[index] = toview;
	
	
	[UIView commitAnimations];
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
}	


- (void)dealloc {
    [super dealloc];
}


@end
