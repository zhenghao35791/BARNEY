//
//  GameObject.m
//  Soccer
//
//  Created by Finguitar on 14/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
@synthesize name = _name;
@synthesize peerID = _peerID;
@synthesize positionX = _positionX;
@synthesize positionY = _positionY;
@synthesize receivedResponse = _receivedResponse;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id) initWithPostion :(float)positionX positionY:(float)positionY
{
    self = [super init];
    if(self)
    {
        self.positionX = positionX;
        self.positionY = positionY;
    }
    return self;
}

-(int)count{
    return 1;
}

- (void)dealloc
{
#ifdef DEBUG
    // NSLog(@"dealloc player %@", self);
#endif
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = (%f, %f)", [super description], self.peerID, self.name, self.positionX, self.positionY];
}



@end
