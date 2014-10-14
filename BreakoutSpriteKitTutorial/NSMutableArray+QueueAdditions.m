//
//  NSMutableArray+QueueAdditions.m
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray (QueueAdditions)
- (id) dequeue {
    if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
        id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        //[[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject {
    [self addObject:anObject];
    //this method automatically adds to the end of the array
}

@end
