//
//  LeaseRecord.h
//  ContentionApp
//
//  Created by Tom Lodge on 18/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LeaseRecord : NSObject {
	NSString * macaddr;
	NSString * name;
}

@property(nonatomic,retain) NSString* macaddr;
@property(nonatomic,retain) NSString* name;

-(id) initWithValues:(NSString *) macaddr name:(NSString*) n;
@end
