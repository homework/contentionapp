//
//  DeviceNameAlert.h
//  ContentionApp
//
//  Created by Tom Lodge on 27/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceView.h"

@interface NameAlert : UIAlertView {
	DeviceView *deviceView;

}

@property(nonatomic, retain) DeviceView *deviceView;

@end
