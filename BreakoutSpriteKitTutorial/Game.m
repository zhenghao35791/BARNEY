//
//  Game.m
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "Game.h"

#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "PacketOtherClientQuit.h"
#import "PacketGameInfo.h"
#import "GameIncomeQueue.h"
#import "GameOutcomeQueue.h"

typedef enum
{
	GameStateWaitingForSignIn,
	GameStateWaitingForReady,
	GameStateDealing,
	GameStatePlaying,
	GameStateGameOver,
	GameStateQuitting,
}
GameState;
@implementation Game
{
    GameState _state;
    GKSession *_session;
    NSString *_serverPeerID;
	NSString *_localPlayerName;
    NSMutableDictionary *_players;
    NSString *_playerName;
}

@synthesize delegate = _delegate;
@synthesize isServer = _isServer;


- (id)init
{
    if((self = [super init]))
    {
        _players = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
    NSLog(@"----game instance is %@", self);
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc game%@", self);
#endif
}

#pragma mark - Game Logic

- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
    self.isServer = NO;
    _playerName = name;
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
	_serverPeerID = peerID;
	_localPlayerName = name;
    
	_state = GameStateWaitingForSignIn;
    
	[self.delegate gameWaitingForServerReady:self];
}

- (void) startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
    self.isServer = YES;
    _playerName = name;
    _session = session;
    _session.available = NO;
    _session.delegate = self;
    [_session setDataReceiveHandler:self withContext:nil];
    _state = GameStateWaitingForSignIn;
    [self.delegate gameWaitingForClientsReady:self];
    
    
//    Player *player = [[Player alloc] init];
//    player.name = name;
//    player.peerID = _session.peerID;
//    [_players setObject:player forKey:player.peerID];
//    
//    //add a player object for each client
//    int index = 0;
//    for(NSString *peerID in clients)
//    {
//        Player *player = [[Player alloc] init];
//        player.peerID = peerID;
//        [_players setObject:player forKey:player.peerID];
//        if(index == 0)
//        {
//            player.positionX =(float) 768/2.0;
//            player.positionY = (float)1024/2.0;
//            
//        }
//        index ++;
//        
//    }
    
    Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
    [self sendPacketToAllClients:packet];
}

- (void)sendPacketToAllClients:(Packet *)packet
{
    [_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop) {
        obj.receivedResponse = [_session.peerID isEqualToString:obj.peerID];
    }];
    
    GKSendDataMode dataMode = GKSendDataReliable;
    NSData *data = [packet data];
    NSError *error;
    if (![_session sendDataToAllPeers:data withDataMode:dataMode error:&error])
    {
        NSLog(@"Error sending data to clients: %@", error);
    }
}

- (Player *)playerWithPeerID:(NSString *)peerID
{
    return [_players objectForKey:peerID];
}

- (void)quitGameWithReason:(QuitReason)reason
{
    _state = GameStateQuitting;
    
	[_session disconnectFromAllPeers];
	_session.delegate = nil;
	_session = nil;
    
	[self.delegate game:self didQuitWithReason:reason];
}

- (void)clientDidDisconnect:(NSString *)peerID
{
    if (_state != GameStateQuitting)
    {
        Player *player = [self playerWithPeerID:peerID];
        if (player != nil)
        {
            [_players removeObjectForKey:peerID];
            if (_state != GameStateWaitingForSignIn)
            {
                // Tell the other clients that this one is now disconnected.
                if (self.isServer)
                {
                    PacketOtherClientQuit *packet = [PacketOtherClientQuit packetWithPeerID:peerID];
                    [self sendPacketToAllClients:packet];
                }			
                
                [self.delegate game:self playerDidDisconnect:player];
            }
        }
    }
}


#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, state);
#endif
    
    if (state == GKPeerStateDisconnected)
    {
        NSLog(@"quitGame, %@", peerID);
        if (self.isServer)
        {
            [self clientDidDisconnect:peerID];
        }
        else if([peerID isEqualToString:_serverPeerID])
        {
            [self quitGameWithReason:QuitReasonConnectionDropped];
        }
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[session denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
    NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
    
    Packet *packet = [Packet packetWithData:data];
    if (packet == nil)
    {
        NSLog(@"Invalid packet: %@", data);
        return;
    }
    
    Player *player = [self playerWithPeerID:peerID];
    if(player != nil)
    {
        player.receivedResponse =YES;
    }
    
    if (self.isServer)
        [self serverReceivedPacket:packet fromPlayer:player];
    else
        [self clientReceivedPacket:packet];
}

- (BOOL)receivedResponsesFromAllPlayers
{
    for (NSString *peerID in _players)
    {
        Player *player = [self playerWithPeerID:peerID];
        if (!player.receivedResponse)
            return NO;
    }
    return YES;
}

- (void)serverReceivedPacket:(Packet *)packet fromPlayer:(Player *)player
{
    NSLog(@"server received from client '%@'", packet);
    switch (packet.packetType)
    {
        case PacketTypeSignInResponse:
            if (_state == GameStateWaitingForSignIn)
            {
                player.name = ((PacketSignInResponse *)packet).playerName;
                
                if ([self receivedResponsesFromAllPlayers])
                {
                    _state = GameStateWaitingForReady;
                    
                    NSLog(@"all clients have signed in");
                    Packet *packet = [PacketServerReady packetWithPlayers:_players];
                    [self sendPacketToAllClients:packet];
                }
                
                NSLog(@"server received sign in from client '%@'", player.name);
            }
            break;
            
        case PacketTypeClientReady:
            if (_state == GameStateWaitingForReady && [self receivedResponsesFromAllPlayers])
            {
                [self beginGame];
            }
            break;
        case PacketTypeGame:
            if(_state == GameStatePlaying)
            {
                [self handleGameInfoPacket:((PacketGameInfo *)packet)];
            }
            break;
            
        default:
            NSLog(@"Server received unexpected packet: %@", packet);
            break;
    }
}

- (void) updateGamePosToAllClients :(NSMutableArray *)gameInfos
{
    NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:2];
    __block int index = 0;
    [_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
     {
         Player *playerInfo = [gameInfos objectAtIndex:index];
         [players setObject:playerInfo forKey:obj.peerID];
         index = index + 1;
     }];
    
    PacketGameInfo *packet = [PacketGameInfo packetWithPlayers:players];
    [self sendPacketToAllClients:packet];
}

- (void)clientReceivedPacket:(Packet *)packet
{
    switch (packet.packetType)
    {
        NSLog(@"Client received  packet: %@", packet);
        case PacketTypeSignInRequest:
            if (_state == GameStateWaitingForSignIn)
            {
                _state = GameStateWaitingForReady;
                
                Packet *packet = [PacketSignInResponse packetWithPlayerName:_localPlayerName];
                [self sendPacketToServer:packet];
            }
            break;
            
        case PacketTypeServerReady:
            if (_state == GameStateWaitingForReady)
            {
                _players = ((PacketServerReady *)packet).players;
               
                Packet *packet = [Packet packetWithType:PacketTypeClientReady];
                [self sendPacketToServer:packet];
                
                [self beginGame];
                
                NSLog(@"the players are: %@", _players);
                
            }
             break;
        case PacketTypeOtherClientQuit:
            if(_state != GameStateQuitting)
            {
                PacketOtherClientQuit *quitPacket = ((PacketOtherClientQuit *)packet);
                //[self clientDidDisconnect:quitPacket.peerID];
            }
             break;
            
        case PacketTypeGame:
            if(_state == GameStatePlaying)
            {
                [self handleGameInfoPacket:((PacketGameInfo *)packet)];
            }
            break;
        default:
            NSLog(@"Client received unexpected packet: %@", packet);
            break;
    }
}

- (void)handleGameInfoPacket:(PacketGameInfo *)packet
{

    NSLog(@"pack received %@", packet);
    //Player *player = tmpPlayer;
    //NSLog(@"new packet game %@", packet.packetType);

    [packet.players enumerateKeysAndObjectsUsingBlock:^(id key, Player *tmpPlayer, BOOL *stop)
     {
        
         [GameIncomeQueue addContent:tmpPlayer];

     }];
}



- (void)beginGame
{
    _state = GameStatePlaying;
    [self.delegate gameDidBegin:self isServer:self.isServer localName:_playerName];
    
    [self.gameControllDelegate initSceneGameInstance:self];
    
    //NSCondition *ticketCondition = [[NSCondition alloc] init];
    NSThread *ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
    
    NSLog(@"out queue number %d", [GameOutcomeQueue count]);

}

- (void)run{
    while (true)
    {
        //NSLog(@"out queue number %d", [GameOutcomeQueue count]);
        if([GameOutcomeQueue count] > 0)
        {
        
          NSMutableDictionary *players = [NSMutableDictionary dictionaryWithCapacity:2];
          __block int index = 0;
            Player *playerInfo = [GameOutcomeQueue dequeue];

            [players setObject:playerInfo forKey:@"Game"];
        
            PacketGameInfo *packet = [PacketGameInfo packetWithPlayers:players];
            [self sendPacketToAllClients:packet];
        }

    }
}

- (void)sendPacketToServer:(Packet *)packet
{
    GKSendDataMode dataMode = GKSendDataReliable;
    NSData *data = [packet data];
    NSError *error;
    if (![_session sendData:data toPeers:[NSArray arrayWithObject:_serverPeerID] withDataMode:dataMode error:&error])
    {
        NSLog(@"Error sending data to server: %@", error);
    }
}



@end
