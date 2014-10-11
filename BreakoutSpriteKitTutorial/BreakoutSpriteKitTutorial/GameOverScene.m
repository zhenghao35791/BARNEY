//
//  GameOverScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Köhler on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "GameOverScene.h"
#import "BreakoutGameScene.h"

@implementation GameOverScene

- (id)initWithSize:(CGSize)size playerWon:(NSString *)results
{
    self = [super initWithSize:size];
    if (self) {
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        // add lable
        SKLabelNode* gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameOverLabel.fontSize = 42;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200);
        if ([results isEqualToString:@"win"]) {
            gameOverLabel.text = @"Congratulation";
        }
        else if([results isEqualToString:@"lose"]) {
            gameOverLabel.text = @"You lose the game";
        }
        else if([results isEqualToString:@"draw"]) {
            gameOverLabel.text = @"Draw";
        }
        [self addChild:gameOverLabel];
        
        // add continue button
        SKLabelNode* gameContinueLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameContinueLabel.fontSize = 30;
        gameContinueLabel.position = CGPointMake(CGRectGetMidX(self.frame)+200, CGRectGetMidY(self.frame)-200);
        gameContinueLabel.text = @"Click to try again";
        [self addChild:gameContinueLabel];
        
        // add Home
        SKLabelNode* goHomeLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        goHomeLabel.fontSize = 30;
        goHomeLabel.position = CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)-200);
        goHomeLabel.text = @"Home";
        [self addChild:goHomeLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
    
    BreakoutGameScene* breakoutGameScene = [[BreakoutGameScene alloc] initWithSize:self.size];
    // 2
    [self.view presentScene:breakoutGameScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    //2
    if(![_selectedNode isEqual:touchedNode]) {
        [_selectedNode removeAllActions];
        [_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
        _selectedNode = touchedNode;
        //3
    }
}

@end
