//
//  Package.m
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Packet.h"
#import "NSData+SnapAdditions.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "PacketOtherClientQuit.h"
#import "Player.h"
#import "PacketGameInfo.h"

const size_t PACKET_HEADER_SIZE = 10;
@implementation Packet

@synthesize packetType = _packetType;

+ (id)packetWithType:(PacketType)packetType
{
    return [[[self class] alloc] initWithType:packetType];
}

- (id)initWithType:(PacketType)packetType
{
    if ((self = [super init]))
    {
        self.packetType = packetType;
    }
    return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
    // base class does nothing
}

- (NSData *)data
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
    [data rw_appendInt32:'SNAP'];   // 0x534E4150
    [data rw_appendInt32:0];
    [data rw_appendInt16:self.packetType];
    
    [self addPayloadToData:data];
    return data;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

+ (id)packetWithData:(NSData *)data
{
    if ([data length] < PACKET_HEADER_SIZE)
    {
        NSLog(@"Error: Packet too small");
        return nil;
    }
    
    if ([data rw_int32AtOffset:0] != 'SNAP')
    {
        NSLog(@"Error: Packet has invalid header");
        return nil;
    }
    
    int packetNumber = [data rw_int32AtOffset:4];
    PacketType packetType = [data rw_int16AtOffset:8];
    
    Packet *packet;
    
    switch (packetType)
    {
        case PacketTypeSignInRequest:
        case PacketTypeClientReady:
            packet = [Packet packetWithType:packetType];
            break;
            
        case PacketTypeSignInResponse:
            packet = [PacketSignInResponse packetWithData:data];
            break;
        case PacketTypeServerReady:
            packet = [PacketServerReady packetWithData:data];
            break;
            
        case PacketTypeOtherClientQuit:
            packet = [PacketOtherClientQuit packetWithData:data];
            break;
        case PacketTypeGame:
            packet = [PacketGameInfo packetWithData:data];
            break;
            
        default:
            NSLog(@"Error: Packet has invalid type");
            return nil;
    }
    
    return packet;
}


- (void)addPlayers:(NSMutableDictionary *)players toPayload:(NSMutableData *)data
{
    [players enumerateKeysAndObjectsUsingBlock:^(id key, Player *array, BOOL *stop)
     {
         //peer id
         [data rw_appendString:key];
         //player info number
         [data rw_appendInt8:[array count]];
         
         Player *player = array;
         [data rw_appendFloat:player.positionX];
         [data rw_appendFloat:player.positionY];
         [data rw_appendString:player.name];
     }];
}

+ (NSMutableDictionary *)playerFromData:(NSData *)data atOffset:(size_t) offset
{
    size_t count;
    
    NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:2];
    
    while (offset < [data length])
    {
        NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
        
        // usually one
        int numberOfPlayerInfos = [data rw_int8AtOffset:offset];
        offset += 1;
        
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfPlayerInfos];
        
//        for (int t = 0; t < numberOfPlayerInfos; ++t)
//        {
            float positionX = [data rw_floatAtOffset:offset];
            offset += sizeof(float);
            
            float positionY = [data rw_floatAtOffset:offset];
            offset += sizeof(float);
            
            Player *player = [[Player alloc] initWithPostion:positionX positionY:positionY];
            player.name = [data rw_stringAtOffset:offset bytesRead:&count];
            offset += count;
            
//            [array addObject:player];
//        }
        
        [players setObject:player forKey:peerID];
    }
    
    return players;
}

@end
