//
//  Game.h
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@class Game;
@protocol GameDelegate <NSObject>

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason;
- (void)gameWaitingForServerReady:(Game *)game;
- (void)gameWaitingForClientsReady:(Game *)game;
- (void)gameDidBegin:(Game *)game;
- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer;

@end

@protocol GameControllDelegate<NSObject>
- (void)updatePlayerPosition:(Game *)game info:(NSMutableDictionary *)gameInfo;
- (void)initSceneGameInstance:(Game *)game;

@end


@interface Game : NSObject<GKSessionDelegate>
@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, weak) id <GameControllDelegate> gameControllDelegate;
@property (nonatomic, assign) BOOL isServer;

- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)quitGameWithReason:(QuitReason)reason;
- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)client;
- (Player *)playerWithPeerID:(NSString *)peerID;
- (void) updateGamePosToAllClients :(NSMutableArray *)gameInfos;


@end
