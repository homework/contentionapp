#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PDColoredProgressView.h"
#import "TouchResponse.h"

@interface DeviceView : UIView {
	UIImage *deviceImage;
	NSString *name;
	UILabel *namelabel;
	//OCProgress* bandwidthbar;
	PDColoredProgressView *bandwidthbar;
	int index;
	UIViewController<TouchResponse>* touchDelegate;
}

@property (nonatomic, retain) UIImage *deviceImage;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) NSString *name;
//@property (nonatomic, retain) OCProgress *bandwidthbar;
@property (nonatomic, retain) PDColoredProgressView* bandwidthbar;
@property (nonatomic, retain) UIViewController<TouchResponse>* touchDelegate;
@property (nonatomic, assign) int index;
// Initializer for this object

-(id) initWithValues:(NSString *)name position:(int)position bandwidth:(float) bandwidth frame:(CGRect) frame imageindent:(float) i ;
-(void) update:(int) index bandwidth:(float) bandwidth;

@end
