//
//  DeviceView.h
//  ContentionApp
//
//  Created by Tom Lodge on 07/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TouchResponse.h"

@interface DeviceView : UIView {
	
	CAShapeLayer *devicea;
	CAShapeLayer *deviceb;
	CAShapeLayer *devicec;
	CAShapeLayer *deviceatitle;
	CAShapeLayer *devicebtitle;
	CAShapeLayer *devicectitle;
	UIViewController <TouchResponse> *delegate;
}

@property(nonatomic, retain) CAShapeLayer *devicea;
@property(nonatomic, retain) CAShapeLayer *deviceb;
@property(nonatomic, retain) CAShapeLayer *devicec;
@property(nonatomic, retain) CAShapeLayer *deviceatitle;
@property(nonatomic, retain) CAShapeLayer *devicebtitle;
@property(nonatomic, retain) CAShapeLayer *devicectitle;
@property(nonatomic, retain) UIViewController <TouchResponse> *delegate;
@end
