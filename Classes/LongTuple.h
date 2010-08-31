//
//  LongTuple.h
//  ContentionApp
//
//  Created by Tom Lodge on 31/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LongTuple : NSObject {
	long first;
	long second;
}

@property(nonatomic, assign) long first;
@property(nonatomic, assign) long second;
@end
