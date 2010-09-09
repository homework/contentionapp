//
//  CustomImagePicker.h
//  ContentionApp
//
//  Created by Tom Lodge on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceView.h"

@interface CustomImagePicker : UIViewController {
	DeviceView *deviceView;
	UIViewController *parent;
}


@property(nonatomic,retain) DeviceView *deviceView;
@property(nonatomic, assign) UIViewController *parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(DeviceView *)view;

@end
