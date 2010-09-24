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
#import "DeviceNameAlert.h"
#import "UserEventLogger.h"
#import "ImageList.h"

@interface ApplicationViewController : UIViewController {
	NSMutableArray *sorteddata;
	ViewManager *vm;
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ViewManager* vm;


@end
