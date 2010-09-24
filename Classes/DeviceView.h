#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PDColoredProgressView.h"
#import "TouchResponse.h"

@interface DeviceView : UIView {
	UIImage *deviceImage;
	NSString *name;
	NSString *identifier;
	UILabel *namelabel;
	PDColoredProgressView *bandwidthbar;
	int index;
	UIViewController<TouchResponse>* touchDelegate;
	CGRect bigframe;
}

@property (nonatomic, retain) UIImage *deviceImage;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) PDColoredProgressView* bandwidthbar;
@property (nonatomic, retain) UIViewController<TouchResponse>* touchDelegate;
@property (nonatomic, assign) CGRect bigframe;
@property (nonatomic, assign) int index;
// Initializer for this object

-(id) initWithValues:(NSString *) identifier name:(NSString *)name position:(int)position bandwidth:(float) bandwidth frame:(CGRect) frame image:(NSString*)i  imageindent:(float) i ;
-(void) update:(int) index bandwidth:(float) bandwidth;
-(void) updateImage:(NSString *)image;
-(void) updateName:(NSString *)name;
@end
