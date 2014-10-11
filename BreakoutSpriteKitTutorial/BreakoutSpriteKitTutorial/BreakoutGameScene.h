//
//  MyScene.h
//  BreakoutSpriteKitTutorial
//

//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BreakoutGameScene : SKScene<SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property SKSpriteNode *selectedNode;
@property SKSpriteNode *player1;
@property SKSpriteNode *player2;
@property SKSpriteNode *aiForward;
@property SKSpriteNode *aiKeeper;
@property SKSpriteNode *soccer;
@property SKSpriteNode *gateUp;
@property SKSpriteNode *gateDown;
@property SKSpriteNode *background;
@property SKLabelNode *internal;
@property SKLabelNode *myScore;
@property SKLabelNode *aIcon;
@property SKLabelNode *enemyScore;


@end
