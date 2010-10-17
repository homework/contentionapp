//
//  ApplicationViewController.h
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchResponse.h"
#import "NetworkData.h"
#import "ViewManager.h"
#import "ApplicationSubViewController.h"
#import "ApplicationImageLookup.h"
#import "CustomImagePicker.h"
#import "NameAlert.h"
#import "UserEventLogger.h"
#import "ImageList.h"
#import "HoverView.h"

@interface ApplicationViewController : UIViewController <TouchResponse> {
	NSMutableArray *sorteddata;
	ViewManager *vm;
	HoverView *hoverView;
	NSTimer* myTimer;
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ViewManager* vm;
@property(nonatomic,retain) HoverView *hoverView;


@end
