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
#import "NodeTuple.h"

#define DEVICES  7

static const int APPLICATION = 0;
static const int DEVICE = 1;

@interface ViewManager : NSObject {
	UIView *view;
	UIViewController<TouchResponse> *viewController;
	DeviceView * myviews[DEVICES+1];
}

@property (nonatomic,retain) UIView* view;
@property (nonatomic,retain) UIViewController<TouchResponse>* viewController;


-(id) initWithView:(UIView *) view data:(NSMutableArray*)data viewcontroller:(UIViewController<TouchResponse> *)vc ;
-(void) update:(NSMutableArray *)data;
-(DeviceView*) viewForName:(NSString *) name;


@end
