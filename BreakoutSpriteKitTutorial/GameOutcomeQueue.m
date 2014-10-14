//
//  GameIncomeQueue.m
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "GameOutcomeQueue.h"
#import "Global.h"

static NSMutableArray *outcomeQueue;
static int count1;
@implementation GameOutcomeQueue

+(void) addContent:(Player *)str
{
    if(outcomeQueue == nil)
    {
       outcomeQueue = [Global outComeQueueSin];
    }
    [outcomeQueue enqueue:str];
}

+ (Player *)dequeue
{
    if(outcomeQueue == nil)
    {
        outcomeQueue = [Global outComeQueueSin];
    }
    return (Player *)[outcomeQueue dequeue];
}

+(int)count
{
    return [outcomeQueue count];
}

+(void) addCount
{
    count1 ++;
}

+ (int) getCount
{
    return count1;
}

@end
