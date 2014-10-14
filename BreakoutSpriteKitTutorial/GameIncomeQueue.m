//
//  GameIncomeQueue.m
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "GameIncomeQueue.h"
#import "Global.h"

static NSMutableArray *incomeQueue;
@implementation GameIncomeQueue

+(void) addContent:(Player *)str
{
    if(incomeQueue == nil)
    {
        incomeQueue = [Global imComeQueueSin];
    }
    [incomeQueue enqueue:str];
}

+ (Player *)dequeue
{
    if(incomeQueue == nil)
    {
        incomeQueue = [Global imComeQueueSin];
    }
    return (Player *)[incomeQueue dequeue];
}

+(int)count
{
    return [incomeQueue count];
}

@end
