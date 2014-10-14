//
//  NSData+SnapAdditions.h
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SnapAdditions)
- (int)rw_int32AtOffset:(size_t)offset;
- (short)rw_int16AtOffset:(size_t)offset;
- (char)rw_int8AtOffset:(size_t)offset;
- (NSString *)rw_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount;
- (float)rw_floatAtOffset:(size_t)offset;
@end

@interface NSMutableData (SnapAdditions)

- (void)rw_appendInt32:(int)value;
- (void)rw_appendInt16:(short)value;
- (void)rw_appendInt8:(char)value;
- (void)rw_appendString:(NSString *)string;
- (void)rw_appendFloat:(float)value;


@end
