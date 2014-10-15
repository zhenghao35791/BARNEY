//
//  PacketGameInfo.h
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Packet.h"
@interface PacketGameInfo : Packet

@property (nonatomic, strong) NSDictionary *players;

+(id) packetWithPlayers:(NSDictionary *)players;

@end
