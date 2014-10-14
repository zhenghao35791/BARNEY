//
//  PacketServerReady.h
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Packet.h"

@interface PacketServerReady : Packet

@property (nonatomic, strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players;

@end
