//
//  DevicesTextInputView.h
//  ContentionApp
//
//  Created by Tom Lodge on 20/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DevicesTextInputView : UIView {
	NSString* name;
	UIImage *deviceImage;
	int index;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *deviceImage;
@property (nonatomic, assign) int index;



-(id) initWithValues:(NSString *) nodename position:(int) position image:(NSString *) image imageindent:(float) i frame:(CGRect) frame;
-(void) update:(int)p bandwidth:(float)bandwidth;
@end
