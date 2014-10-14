//
//  FootBall.m
//  Soccer
//
//  Created by Finguitar on 14/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "FootBall.h"

@implementation FootBall

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

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = (%f, %f)", [super description], self.peerID, self.name, self.positionX, self.positionY];
}

@end
