//
//  GameOverScene.h
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Köhler on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene<SKPhysicsContactDelegate>

- (id)initWithSize:(CGSize)size playerWon:(NSString *)result;
@property SKSpriteNode *selectedNode;
@end
