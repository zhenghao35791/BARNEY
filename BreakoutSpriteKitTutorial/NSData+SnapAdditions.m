//
//  NSData+SnapAdditions.m
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "NSData+SnapAdditions.h"


union intToFloat
{
    uint32_t i;
    float fp;
};

@implementation NSData (SnapAdditions)
- (int)rw_int32AtOffset:(size_t)offset
{
    const int *intBytes = (const int *)[self bytes];
    return ntohl(intBytes[offset / 4]);
}

- (short)rw_int16AtOffset:(size_t)offset
{
    const short *shortBytes = (const short *)[self bytes];
    return ntohs(shortBytes[offset / 2]);
}

- (char)rw_int8AtOffset:(size_t)offset
{
    const char *charBytes = (const char *)[self bytes];
    return charBytes[offset];
}

- (float)rw_floatAtOffset:(size_t)offset
{
//    const float *floatBytes = (const float*)[self bytes];
//    union intToFloat convert;
//    const uint32_t* bytes = [self bytes] + offset;
//    convert.i = CFSwapInt32BigToHost(*bytes);
//    
//    const float value = convert.fp;
    float z;
    //const float *floatBytes = (const float *)[self bytes];
    //return 1.0f;
   [self getBytes:&z range:NSMakeRange (offset, sizeof(float))];
    return z;
}

- (NSString *)rw_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount
{
    const char *charBytes = (const char *)[self bytes];
    NSString *string = [NSString stringWithUTF8String:charBytes + offset];
    *amount = strlen(charBytes + offset) + 1;
    return string;
}


@end

@implementation NSMutableData (SnapAdditions)



- (void)rw_appendInt32:(int)value
{
    value = htonl(value);
    [self appendBytes:&value length:4];
}

- (void)rw_appendInt16:(short)value
{
    value = htons(value);
    [self appendBytes:&value length:2];
}

- (void)rw_appendInt8:(char)value
{
    [self appendBytes:&value length:1];
}

- (void)rw_appendString:(NSString *)string
{
    const char *cString = [string UTF8String];
    [self appendBytes:cString length:strlen(cString) + 1];
}

- (void)rw_appendFloat:(float)value
{
    [self appendBytes:&value length:sizeof(float)];
}

@end