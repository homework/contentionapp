//
//  RootViewController.h
//  ContentionApp
//
//  Created by Tom Lodge on 25/06/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchResponse.h"
#import "NodeTuple.h"
#import "DevicesView.h"
#import "NetworkData.h"

@interface DeviceViewController : UIViewController <TouchResponse>{
	NSMutableArray *sorteddata;
	DevicesView *devicesView;
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) DevicesView* devicesView;

@end
