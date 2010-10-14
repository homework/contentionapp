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
#import "NameAlert.h"
#import "NameResolver.h"
#import "UserEventLogger.h"
#import "ImageList.h"
#import "HoverView.h"

@interface DeviceViewController : UIViewController <TouchResponse, UIAlertViewDelegate>{
	NSMutableArray *sorteddata;
	ViewManager *vm;
	NSArray *_thumbs;
	NSTimer* myTimer;
	HoverView *hoverView; 
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ViewManager* vm;
@property(nonatomic,retain) HoverView *hoverView;

@end
