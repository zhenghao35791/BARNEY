//
//  MyScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Reichart on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
/////

#import "BreakoutGameScene.h"
#import "GameOverScene.h"

static NSString* soccerCategoryName = @"soccer";
static NSString* player1CategoryName = @"player1";
static NSString* player2CategoryName = @"player2";
static NSString* gateRedCategoryName = @"gateRedCategoryName";
static NSString* gateBlueCategoryName = @"gateBlueCategoryName";
static NSString* aiKeeperCategoryName = @"aiKeeperCategoryName";


static const uint32_t soccerCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t borderCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t player1Category = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t player2Category = 0x1 << 3; // 00000000000000000000000000001000
static const uint32_t gateRedCategory = 0x1 << 4;
static const uint32_t gateBlueCategory = 0x1 << 5;
static const uint32_t aiKeeperCategory = 0x1 << 6;
static const uint32_t aiForwardCategory = 0x1 << 7;





@interface BreakoutGameScene()

@property (nonatomic) BOOL isFingerOnPlayer1;
@property (nonatomic) BOOL isFingerOnPlayer2;

@end


@implementation BreakoutGameScene

NSTimeInterval startTime;
NSTimeInterval endTime;
int internal = 0;
int gateRedScore = 0;
int gateBlueScore = 0;
int maxGameTime = 30;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        internal = 0;
        gateRedScore = 0;
        gateBlueScore = 0;
        maxGameTime = 30;
        
        // Setup the scene
       screenRect = [[UIScreen mainScreen]bounds];
       screenHeight = screenRect.size.height;
       screenWidth = screenRect.size.width;
        
        
        //adding backgroud
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpeg"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];
        [self addChild:_background ];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        
        // 1 Create an physics body that borders the screen
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody;
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody.friction = 0.0f;
        
        // 1
        _soccer = [SKSpriteNode spriteNodeWithImageNamed: @"soccer.png"];
        _soccer.name = soccerCategoryName;
        _soccer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:_soccer];
        
        // 2
        _soccer.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_soccer.frame.size.width/2];
        // 3
        _soccer.physicsBody.friction = 3.6f;
        // 4
        _soccer.physicsBody.restitution = 1.2f;
        // 5
        _soccer.physicsBody.linearDamping = 3.6f;
        // 6
        _soccer.physicsBody.allowsRotation = YES;
        //7
        _soccer.physicsBody.mass = 10;
        
       //////////////////////////////////////// [_soccer.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
        
        _player1 = [[SKSpriteNode alloc] initWithImageNamed: @"player1.png"];
        _player1.name = player1CategoryName;
        _player1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
        [self addChild:_player1];
        _player1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player1.frame.size];
        _player1.physicsBody.restitution = 0.1f;
        _player1.physicsBody.friction = 0.4f;
        _player1.physicsBody.allowsRotation = NO;
        _player1.physicsBody.mass = 100;
        
        
        
        // make physicsBody static
        //////////////////_player1.physicsBody.dynamic = NO;
        // make physicsBody static
        //////////////////// _player2.physicsBody.dynamic = NO;
        
         _player2 = [[SKSpriteNode alloc] initWithImageNamed: @"player2.png"];
        _player2.name = player2CategoryName;
        _player2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 200);
        [self addChild:_player2];
        _player2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player2.frame.size];
        _player2.physicsBody.restitution = 0.1f;
        _player2.physicsBody.friction = 0.2f;
        _player2.physicsBody.allowsRotation = NO;
        _player2.physicsBody.mass = 100;
        
         // ADD GATE down
        _gateUp = [[SKSpriteNode alloc] initWithImageNamed: @"Gate_down_normal.png"];
        _gateUp.position = CGPointMake(screenWidth/2-100,60);
        _gateUp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gateUp.frame.size];
        _gateUp.name = gateRedCategoryName;
        [self addChild:_gateUp];
        
        [self CallingAi];
        
        // ADD GATE up
        _gateDown = [[SKSpriteNode alloc] initWithImageNamed: @"Gate_UP_normal.png"];
        _gateDown.position = CGPointMake(screenWidth/2-100,screenHeight - 70);
        _gateDown.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gateDown.frame.size];
        _gateDown.name = gateBlueCategoryName;
        [self addChild:_gateDown];
        
        _gateUp.physicsBody.dynamic = NO;
        _gateDown.physicsBody.dynamic = NO;
      
        
        CGRect borderRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        SKNode* border = [SKNode node];
        border.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
        [self addChild:border];
        
        border.physicsBody.categoryBitMask = borderCategory;
        _soccer.physicsBody.categoryBitMask = soccerCategory;
        _player1.physicsBody.categoryBitMask = player1Category;
        _player2.physicsBody.categoryBitMask = player2Category;
        _gateUp.physicsBody.categoryBitMask = gateRedCategory;
        _gateDown.physicsBody.categoryBitMask = gateBlueCategory;
        _aiKeeper.physicsBody.categoryBitMask = aiKeeperCategory;
        _aiForward.physicsBody.categoryBitMask = aiForwardCategory;
        
        _soccer.physicsBody.contactTestBitMask = borderCategory | player1Category|player2Category|gateRedCategory|gateBlueCategory|aiForwardCategory|aiKeeperCategory;
        
        self.physicsWorld.contactDelegate = self;
        
        startTime = CACurrentMediaTime();
        
        
        //loading internal
        _internal = [SKLabelNode labelNodeWithFontNamed:@"internalTime"];
        _internal.fontSize = 40;
        _internal.position = CGPointMake(screenWidth-200, screenHeight-50);
        _internal.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter; //good for positioning with other sprites
        _internal.fontColor = [SKColor whiteColor ];
        _internal.name = @"countDown";
        [self addChild:_internal];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
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
        //only for test
        if([[touchedNode name] isEqualToString:player1CategoryName]||[[touchedNode name] isEqualToString:player2CategoryName]) {
        }
    }
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([[_selectedNode name] isEqualToString:player1CategoryName]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _player1.physicsBody.velocity = CGVectorMake(translation.x, translation.y);//speed
        
    }
    if([[_selectedNode name] isEqualToString:player2CategoryName]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _player2.physicsBody.velocity = CGVectorMake(translation.x, translation.y);//speed
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    [self panForTranslation:translation];
}


- (void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
        if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == player1Category) {
        _soccer.physicsBody.velocity = CGVectorMake(secondBody.velocity.dx*5, secondBody.velocity.dy*5);

    }
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == player2Category) {
        _soccer.physicsBody.velocity = CGVectorMake(secondBody.velocity.dx*5, secondBody.velocity.dy*5);

    }

    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == gateRedCategory) {
        NSLog(@"red");
        gateRedScore++;
    }
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == gateBlueCategory) {
        NSLog(@"blue");
        gateBlueScore++;
        
    }
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == aiKeeperCategory ) {
       // NSLog(@"keeper");
        
    }

}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static int maxSpeed = 10;
    float speed = sqrt(_soccer.physicsBody.velocity.dx *_soccer.physicsBody.velocity.dx + _soccer.physicsBody.velocity.dy * _soccer.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        _soccer.physicsBody.linearDamping = 0.7f;
    } else {
        _soccer.physicsBody.linearDamping = 0.1f;
    }
    CGPoint newPositionSoccer = CGPointMake(_soccer.position.x, _soccer.position.y);
    _soccer.position = newPositionSoccer;
    
    endTime = currentTime;
    //NSLog(@"END,%f",endTime);
    internal = (endTime - startTime);
    //NSLog(@"INTERNAL,%d",internal);
    if(maxGameTime -internal>0)
        {  //if counting down to 0 show counter
            _internal.text = [NSString stringWithFormat:@"%i           %i : %i", maxGameTime -internal,gateBlueScore,gateRedScore];
        }
    else{
        NSString *result;
        if(gateRedScore<gateBlueScore){
            result = @"win";
            GameOverScene* gameWonScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:result];
            [self.view presentScene:gameWonScene];
        }
        else if(gateRedScore == gateBlueScore){
            result = @"draw";
            GameOverScene* gameWonScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:result];
            [self.view presentScene:gameWonScene];
        }
        else {
            result = @"lose";
            GameOverScene* gameWonScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:result];
            [self.view presentScene:gameWonScene];
        }
            
        }
    
}


// AI gate keeper
- (void) CallingAi{
    //loading aiKeeper,2
    _aiKeeper = [SKSpriteNode spriteNodeWithImageNamed:@"player1"];
    _aiForward = [SKSpriteNode spriteNodeWithImageNamed:@"player2"];
    _aiKeeper.position = CGPointMake(screenWidth/2, 900);
    _aiForward.position = CGPointMake(screenWidth/2, _aiForward.size.height/2+750);
    _aiKeeper.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_aiKeeper.frame.size];
    _aiForward.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_aiForward.frame.size];
    
    CGMutablePathRef cgpath = CGPathCreateMutable();
    CGPoint start = CGPointMake(_aiKeeper.position.x, _aiKeeper.position.y);
    CGPoint end = CGPointMake(screenWidth/2+150, _aiKeeper.position.y);
    CGPoint path1 = CGPointMake(screenWidth/2 -150, _aiKeeper.position.y);
    CGPoint path2 = CGPointMake(_aiKeeper.position.x, _aiKeeper.position.y);
    CGPathMoveToPoint(cgpath,NULL, start.x, start.y);
    CGPathAddCurveToPoint(cgpath, NULL, path1.x, path1.y, path2.x, path2.y, end.x, end.y);
    SKAction *defend = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:3];
    [self addChild:_aiKeeper];
    [self addChild:_aiForward];
    [_aiKeeper runAction:[SKAction repeatActionForever:(defend)]];
    
}

@end
