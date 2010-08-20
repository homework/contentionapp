//
//  DevicesTextInputView.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DevicesTextInputView.h"


@implementation DevicesTextInputView

@synthesize name;

-(id) initWithValues:(NSString *) nodename frame:(CGRect) frame{
	if ((self = [super initWithFrame:frame])) {
		self.name = nodename;		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
    }
    return self;
}


-(void) updateMyPosition:(int)p{
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
