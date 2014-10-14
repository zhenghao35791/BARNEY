//
//  PacketOtherClientQuit.h
//  Soccer
//
//  Created by Finguitar on 11/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Packet.h"

@interface PacketOtherClientQuit : Packet

@property (nonatomic, copy) NSString *peerID;

+ (id)packetWithPeerID:(NSString *)peerID;

@end
