//
//  MyScene.h
//  BreakoutSpriteKitTutorial
//

//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
//#import "ViewController.h"

@interface BreakoutGameScene3 : SKScene<SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
-(int)getRandomNumberBetween:(int)from to:(int)to;

@property SKSpriteNode *selectedNode;
@property SKSpriteNode *player1;
@property SKSpriteNode *player2;
@property SKSpriteNode *aiForward;
@property SKSpriteNode *aiKeeper;
@property SKSpriteNode *myKeeper;

@property SKSpriteNode *soccer;
@property SKSpriteNode *gateUp;
@property SKSpriteNode *gateDown;
@property SKSpriteNode *background;
@property SKLabelNode *internal;
@property SKLabelNode *myScore;
@property SKLabelNode *aIcon;
@property SKLabelNode *scoringLabel;
@property SKLabelNode *enemyScore;
@property SKSpriteNode *redMushroom;
@property SKSpriteNode *greenMushroom;
@property BOOL isEatingGreen;
@property BOOL isEatingRed;
@property NSInteger internalCounter;
@property int gateUpScore;
@property int gateDownScore;
@property int maxGameTime;

//@property ViewController *spyViewCotroller;


@end
