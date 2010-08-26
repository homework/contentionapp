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

@interface DeviceViewController : UIViewController <TouchResponse>{
	NSMutableArray *sorteddata;
	ViewManager *vm;
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ViewManager* vm;


@end
