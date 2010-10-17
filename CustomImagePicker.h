//
//  CustomImagePicker.h
//  ContentionApp
//
//  code taken from:
//  http://www.raywenderlich.com/130/how-to-write-a-custom-image-picker-like-uiimagepicker/
//

#import <UIKit/UIKit.h>
#import "DeviceView.h"

@interface CustomImagePicker : UIViewController {
	DeviceView *deviceView;
	UIViewController *parent;
}


@property(nonatomic,retain) DeviceView *deviceView;
@property(nonatomic, assign) UIViewController *parent;

			
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil view:(DeviceView*) v imagelist:(NSArray*)images parent:(UIViewController *)p;

@end
