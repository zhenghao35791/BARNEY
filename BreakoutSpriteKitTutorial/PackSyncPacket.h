//
//  PackSyncPacket.h
//  Soccer
//
//  Created by Finguitar on 13/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Packet.h"

@interface PackSyncPacket : Packet
@property (nonatomic, assign) int sequencer;

+(id) packetWithSequencer:(NSDictionary *)players;
@end
