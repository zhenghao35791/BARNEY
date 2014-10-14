//
//  Package.h
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    PacketTypeSignInRequest = 0x64,    // server to client
    PacketTypeSignInResponse,          // client to server
    
    PacketTypeServerReady,             // server to client
    PacketTypeClientReady,             // client to server
    
    PacketTypeGame,               // server to client
    PacketTypeClientGame,        // client to server
    
    PacketTypeResult,
    PacketTypeClientResult,
    
    PacketSyncPacket,
    
    PacketTypeActivatePlayer,          // server to client
    PacketTypeClientTurnedCard,        // client to server
    
    PacketTypePlayerShouldSnap,        // client to server
    PacketTypePlayerCalledSnap,        // server to client
    
    PacketTypeOtherClientQuit,         // server to client
    PacketTypeServerQuit,              // server to client
    PacketTypeClientQuit,              // client to server
}
PacketType;
const size_t PACKET_HEADER_SIZE;
@interface Packet : NSObject
@property (nonatomic, assign)PacketType packetType;

+ (id)packetWithType: (PacketType)packetType;
- (id)initWithType:(PacketType)packetType;
+ (id)packetWithData:(NSData *)data;

- (NSData *)data;
+ (NSMutableDictionary *)playerFromData:(NSData *)data atOffset:(size_t) offset;
- (void)addPlayers:(NSMutableDictionary *)players toPayload:(NSMutableData *)data;
@end
