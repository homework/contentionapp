//
//  CustomImagePicker.h
//  ContentionApp
//
//  Created by Tom Lodge on 26/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceImageLookup.h"

@interface CustomImagePicker : UIViewController {
	NSString *name;
}

@property(nonatomic,retain) NSString *name;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString *)name;

@end
