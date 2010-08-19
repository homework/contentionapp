
@interface DeviceView : UIView {
	UIImage *deviceImage;
	NSString *name;
	UILabel *namelabel;
	int position;
}

@property (nonatomic, retain) UIImage *deviceImage;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int position;
// Initializer for this object

-(id) initWithValues:(NSString *)name position:(int)position;
-(void) updateMyPosition:(int) position;
@end
