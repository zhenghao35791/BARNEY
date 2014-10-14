//
//  PacketSignInResponse.h
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Packet.h"

@interface PacketSignInResponse : Packet

@property (nonatomic, copy) NSString *playerName;

+ (id)packetWithPlayerName:(NSString *)playerName;

@end