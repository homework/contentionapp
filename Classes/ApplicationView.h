//
//  ApplicationView.h
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TouchResponse.h"
#import "NodeTuple.h"
#import "ApplicationImageLookup.h"

#define DEVICES  7

@interface ApplicationView : UIView {
	

	UIViewController <TouchResponse> *delegate;
	NSMutableArray *nodes;
	CALayer * mylayers[DEVICES+1];
	CALayer * mytitlelayers[DEVICES+1];
}

@property(nonatomic, retain) UIViewController <TouchResponse> *delegate;
@property(nonatomic, retain) NSMutableArray *nodes;

- (id)initWithFrame:(CGRect)frame nodes:(NSMutableArray *) nodes;
- (void) update:(NSMutableArray *) nodes;
-(CGPoint) getCoordinates:(int) position;
@end
