//
//  RootViewController.h
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TouchResponse.h"
#import "NetworkData.h"
#import "ViewManager.h"
#import "DeviceSubViewController.h"
#import "DeviceImageLookup.h"
#import "CustomImagePicker.h"
#import "DeviceNameAlert.h"
#import "NameResolver.h"
#import "UserEventLogger.h"

@interface DeviceViewController : UIViewController <TouchResponse, UIAlertViewDelegate>{
	NSMutableArray *sorteddata;
	ViewManager *vm;
	NSArray *_thumbs;
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ViewManager* vm;

@end
