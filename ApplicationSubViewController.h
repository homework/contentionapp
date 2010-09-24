//
//  ApplicationSubViewController.h
//  ContentionApp
//
//  Created by Tom Lodge on 31/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchResponse.h"
#import "NetworkData.h"
#import "ViewManager.h"
#import "DeviceImageLookup.h"

@interface ApplicationSubViewController : UIViewController <TouchResponse> {
	NSMutableArray *sorteddata;
	ViewManager *vm;
	NSString *node;	
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ViewManager* vm;
@property(nonatomic,retain) NSString* node;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil nodename:(NSString*) n;

@end
