//
//  ViewHandler.h
//  ContentionApp
//
//  Created by Tom Lodge on 25/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DeviceView.h"
#import "NetworkData.h"
#import "ContainerView.h"
#import "NodeTuple.h"
#import "ContainerView.h"

#define DEVICES  7

@interface ViewManager : NSObject {
	UIView *view;
	UIViewController<TouchResponse> *touchDelegate;
	DeviceView * myviews[DEVICES+1];
	int MAXBANDWIDTH;
	NSString * name;
}

@property (nonatomic,retain) UIView* view;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) UIViewController<TouchResponse>* touchDelegate;
@property (nonatomic,assign) int MAXBANDWIDTH;

-(id) initWithView:(UIView *) view data:(NSMutableArray*)data touchdelegate:(UIViewController<TouchResponse> *)touchDelegate name:(NSString*)name;
-(void) update:(NSMutableArray *)data;

@end
