//
//  TouchResponse.h
//  ContentionApp
//
//  Created by Tom Lodge on 27/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


static const int    IMAGE		= 0;
static const int    LABEL		= 1;
static const int    BANDWIDTH	= 2;
static const int    OTHER		= 3;

@protocol TouchResponse
-(void) touched: (int) tag viewname:(NSString *) identifier position: (int) index;
//-(void) touched: (int) tag viewname:(NSString *) view position: (int) index;
-(NSString *) getImage:(NSString *) s;
-(float) getBandwidthProportion:(NSString *) node;


@end
