//
//  ViewHandler.m
//  ContentionApp
//
//  Created by Tom Lodge on 25/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewManager.h"


@interface ViewManager (private)
-(CGPoint) getCoordinates:(int) position;
-(void) createViews:(NSMutableArray*)data;
-(BOOL) containsView:(NSString*) name data:(NSMutableArray*)data;
-(int) findViewIndex:(NSString *) viewname;
-(void) addNewView:(NodeTuple *) node position:(int) pos;
-(void) printTables;
-(void) newNetworkData:(NSNotification *) n;
@end


@implementation ViewManager

@synthesize view;
@synthesize viewController;


const static float	IMAGEINDENT = 215;
const static float	VIEWHEIGHT  = 85;


-(id) initWithView:(UIView *) v data:(NSMutableArray*) data viewcontroller:(UIViewController<TouchResponse>*) vc{
	if(self == [super init]){
		[self setViewController:vc];
		[self setView:v];
		[self createViews:data];
	}
	
	return self;
}



-(BOOL) containsView:(NSString*) name data:(NSMutableArray*)data{
	NSEnumerator *enumerator = [data objectEnumerator];
	NodeTuple* node;
	int count = 0;
	while ( node = [enumerator nextObject]) {
		if (count++ >= DEVICES)
			break;
		if ([name isEqualToString:[node name]])
			return YES;
	}
	return NO;
}

-(void) update:(NSMutableArray *) data{
	
	NSEnumerator *enumerator = [data objectEnumerator];
    NodeTuple* node;
	
	//remove old views here..
	
	for (int i = 0; i < DEVICES; i++){
		if (myviews[i] != NULL){
			DeviceView *current = (DeviceView*) myviews[i]; 
			
			if (![self containsView:current.name data:data]){
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
		
		
		
		[myviews[index] update:position bandwidth:[viewController getBandwidthProportion:[node name]]];
		
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
		return CGPointMake(self.view.bounds.size.width/2,  (10 + (position)*100) + VIEWHEIGHT/2);
	}else{
		return CGPointMake( (INDENT + (self.view.bounds.size.width/4 + (spacer * (position-3)))- (IMAGEINDENT/2)), 330);
	}
}


-(void) addNewView:(NodeTuple *) node position:(int) pos{
	
	NSString* myImage = [self.viewController getImage:[node name]];
	CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, VIEWHEIGHT); 
	ContainerView *container = [[[ContainerView alloc] initWithFrame:frame] retain];
	float bandwidth = [viewController getBandwidthProportion:[node name]];
	DeviceView *pview = [[[DeviceView alloc] initWithValues:[node name] position:pos bandwidth:bandwidth frame:frame image:myImage imageindent:IMAGEINDENT] retain];
	[pview setBackgroundColor:[UIColor clearColor]];
	[pview setTouchDelegate:[self viewController]];
	[container setBackgroundColor:[UIColor clearColor]];
	container.center = [self getCoordinates:pos];
	[container addSubview:pview];
	
	if (pos >=3){
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		CGAffineTransform transform = CGAffineTransformMakeScale(0.5, 0.5);
		pview.transform = transform;
		[UIView commitAnimations];
	}
	
	[self.view addSubview:container];
	
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



-(void) createViews:(NSMutableArray*)data{
	
	
	NSEnumerator *enumerator = [data objectEnumerator];
    NodeTuple* node;
	int count = 0;
    
	while ( (node = [enumerator nextObject])) {
		if (count >= DEVICES)
			break;
		[self addNewView:node position: count];
		count +=1;
	}
	
}

/*
-(void) printTable{
	
	NSEnumerator *enumerator = [self.sorteddata objectEnumerator];
	
	NodeTuple* node;
	
	while ( (node = [enumerator nextObject])) {
		//Window *w = [self.bytehistory objectForKey:[node name]];
		[node print];
		//: w.lastpoll currentpoll:POLLNUMBER];
		//[w print:[node name]];
	}
}
*/

@end