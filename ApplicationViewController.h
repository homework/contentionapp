//
//  ApplicationViewController.h
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeTuple.h"
#import "ApplicationView.h"
#import "NetworkData.h"

@interface ApplicationViewController : UIViewController {
	NSMutableArray *sorteddata;
	ApplicationView *appView;
}

@property(nonatomic,retain) NSMutableArray* sorteddata;
@property(nonatomic,retain) ApplicationView* appView;

@end
