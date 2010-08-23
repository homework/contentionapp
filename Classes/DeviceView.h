#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DeviceView : UIView {
	UIImage *deviceImage;
	NSString *name;
	UILabel *namelabel;
	int index;
}

@property (nonatomic, retain) UIImage *deviceImage;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int index;
// Initializer for this object

-(id) initWithValues:(NSString *)name position:(int)position frame:(CGRect) frame imageindent:(float) i ;
-(void) updateMyPosition:(int) index;

@end
