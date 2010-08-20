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
}

@property (nonatomic, retain) NSString *name;

-(id) initWithValues:(NSString *) nodename frame:(CGRect) frame;
-(void) updateMyPosition:(int)p;
@end
