//
//  ContainerView.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContainerView.h"


@implementation ContainerView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"am container touched");
		UITouch *touch = [touches anyObject];
	CGPoint thePoint = [touch locationInView:self];


	NSLog(@"postion %f, %f", thePoint.x, thePoint.y);
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
