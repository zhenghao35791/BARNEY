//
//  PacketGameInfo.m
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "PacketGameInfo.h"
#import "NSData+SnapAdditions.h"

@implementation PacketGameInfo

@synthesize players = _players;

+(id)packetWithPlayers:(NSDictionary *)players
{
    return [[[self class]alloc] initWithPlayers:players];
}

- (id)initWithPlayers:(NSDictionary *)players
{
    if ((self = [super initWithType:PacketTypeGame]))
    {
        self.players = players;
    }
    return self;
}

+ (id)packetWithData:(NSData *)data
{
    size_t offset = PACKET_HEADER_SIZE;
    size_t count;
    
    NSDictionary *players = [[self class] playerFromData:data atOffset:offset];
    return [[self class] packetWithPlayers:players];
}

- (void)addPayloadToData:(NSMutableData *)data
{
    [self addPlayers:self.players toPayload:data];
}

@end
