//
//  FlowRecord.h
//  ContentionApp
//
//  Created by Tom Lodge on 12/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlowRecord : NSObject {
	long			packets;
	long			bytes;
	int				parallel;
	NSString*		application;
}

@property(nonatomic, assign) long		packets;
@property(nonatomic, assign) long		bytes;
@property(nonatomic, assign) int		parallel;
@property(nonatomic, copy) NSString*	application;
@end
