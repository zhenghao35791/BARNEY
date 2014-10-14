//
//  Global.m
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Global.h"
#import "NSMutableArray+QueueAdditions.h"

@implementation Global


+(NSMutableArray*)imComeQueueSin {
    static NSMutableArray *statArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statArray = [NSMutableArray array];
    });
    return statArray;
}

+(NSMutableArray*)outComeQueueSin {
    static NSMutableArray *statArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statArray = [NSMutableArray array];
    });
    return statArray;
}

@end
