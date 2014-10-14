//
//  GameIncomeQueue.h
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+QueueAdditions.h"
#import "Player.h"

@interface GameOutcomeQueue : NSObject

+ (void)addContent:(Player *)str;
+ (Player *)dequeue;

+ (int)count;

+ (void)addCount;
+ (int)getCount;

@end


