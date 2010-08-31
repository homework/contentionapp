//
//  CustomImagePicker.h
//  ContentionApp
//
//  Created by Tom Lodge on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceImageLookup.h"
#import "DeviceView.h"

@interface CustomImagePicker : UIViewController {
	DeviceView *deviceView;
}

@property(nonatomic,retain) DeviceView *deviceView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(DeviceView *)view;

@end
