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
-(void) removeOldViews:(NSMutableArray *) data;
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
		if ([name isEqualToString:[node identifier]])
			return YES;
	}
	return NO;
}

-(void) update:(NSMutableArray *) data{
	
	NSEnumerator *enumerator = [data objectEnumerator];
    NodeTuple* node;
	
	//remove old views here..
	
	[self removeOldViews:data];
		
	int position = 0;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	
	while ( node = [enumerator nextObject]) {
		
		if (position >= DEVICES)
			break;
		int index = [self findViewIndex:[node identifier]];
		
		if (index == -1){
			[self addNewView:node position:position];
			index = [self findViewIndex:[node identifier]];
		}
		
		CGPoint newPosition = [self getCoordinates:position];
		myviews[index].center = newPosition;
		[myviews[index] update:position bandwidth:[viewController getBandwidthProportion:[node identifier]]];
		
		CGRect bounds;
		
		CGAffineTransform transform;
		if (position < 3){
			transform = CGAffineTransformMakeScale(1.0, 1.0);
			bounds = CGRectMake(0.0, 0.0, 320, 85);

		}
		else{
			transform = CGAffineTransformMakeScale(0.5, 0.5);
			bounds= CGRectMake(0.0, 0.0, 100, 85);
		}
				
		myviews[index].bounds = bounds; 
		myviews[index].transform = transform;
		
		position++;
		
	}
	[UIView commitAnimations];
}


-(void) removeOldViews:(NSMutableArray *) data{
	for (int i = 0; i < DEVICES; i++){
		if (myviews[i] != NULL){
			DeviceView *current = (DeviceView*) myviews[i]; 
			if (![self containsView:current.identifier data:data]){
				[current removeFromSuperview];
				myviews[i] = NULL;
			}
		}
	}	
}

-(DeviceView*) viewForName:(NSString *) identifier{
	int index = [self findViewIndex:identifier];
	if (index != -1){
		return myviews[index];
	}
	return NULL;
}

-(int) findViewIndex:(NSString *) identifier{
	for (int i = 0; i < DEVICES; i++){
		DeviceView *current = (DeviceView *) myviews[i]; 
		if (current != NULL){
			if (current.identifier != nil){
				if ([current.identifier isEqualToString:identifier])
					return i;
			}
		}
	}
	return -1;
}

-(CGPoint) getCoordinates:(int) position{
	int spacer = 80;
	int INDENT =55;
	if (position < 3){
		return CGPointMake(self.view.bounds.size.width/2,  (10 + (position)*100) + VIEWHEIGHT/2);
	}else{
		return CGPointMake( (INDENT + (self.view.bounds.size.width/4 + (spacer * (position-3)))- (IMAGEINDENT/2)), 330);
	}
}


-(void) addNewView:(NodeTuple *) node position:(int) pos{
	
	NSString* myImage = [self.viewController getImage:[node identifier]];
	CGRect frame; 
	if (pos < 3)
		frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, VIEWHEIGHT);
	else
		frame = CGRectMake(0.0, self.view.bounds.size.height, 100, 85);
	
	float bandwidth = [viewController getBandwidthProportion:[node identifier]];
	DeviceView *pview = [[[DeviceView alloc] initWithValues:[node identifier] name:[node name] position:pos bandwidth:bandwidth frame:frame image:myImage imageindent:IMAGEINDENT] retain];
	
	[pview setBackgroundColor:[UIColor clearColor]];
	[pview setTouchDelegate:[self viewController]];
	pview.center = [self getCoordinates:pos];
	
	if (pos >=3){
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		CGAffineTransform transform = CGAffineTransformMakeScale(0.5, 0.5);
		pview.transform = transform;
		pview.bounds= CGRectMake(0.0, 0.0, 100, 85);
		[UIView commitAnimations];
	}
	
	[self.view addSubview:pview];
	
	for (int i = 0; i < DEVICES; i++){
		if (myviews[i] == NULL){
			myviews[i] = pview;
			break;
		}
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

@end
