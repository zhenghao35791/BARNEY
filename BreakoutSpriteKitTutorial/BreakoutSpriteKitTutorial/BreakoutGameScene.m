//
//  MyScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Reichart on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
/////
#import <UIKit/UIKit.h>
#import "BreakoutGameScene.h"

#import "GameOverViewController.h"
#import "ViewController.h"


static NSString* soccerCategoryName = @"soccer";
static NSString* player1CategoryName = @"player1";
static NSString* player2CategoryName = @"player2";
static NSString* gateUpCategoryName = @"gateUpCategoryName";
static NSString* gateDownCategoryName = @"gateDownCategoryName";
static NSString* aiKeeperCategoryName = @"aiKeeperCategoryName";
static NSString* scroingLableCategoryName = @"scroingLableCategoryName";


static const uint32_t soccerCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t borderCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t player1Category = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t player2Category = 0x1 << 3; // 00000000000000000000000000001000
static const uint32_t gateUpCategory = 0x1 << 4;
static const uint32_t gateDownCategory = 0x1 << 5;
static const uint32_t aiKeeperCategory = 0x1 << 6;
static const uint32_t aiForwardCategory = 0x1 << 7;
static const uint32_t greenMushroomCategory = 0x1 << 8;
static const uint32_t redMushroomCategory = 0x1 << 9;





@interface BreakoutGameScene()

@property (nonatomic) BOOL isFingerOnPlayer1;
@property (nonatomic) BOOL isFingerOnPlayer2;
@property (nonatomic) BOOL is5Times;

@end


@implementation BreakoutGameScene

NSTimeInterval startTime;
NSTimeInterval endTime;
NSTimeInterval eatGreenTime = 0;
NSTimeInterval eatRedTime = 0;







-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _maxGameTime = 60;
        _gateDownScore = 0;
        _gateUpScore = 0;
        _internalCounter= 0;
        _isEatingGreen = FALSE;
        _isEatingRed = FALSE;
        _is5Times = false;
        //NSString *myScore = [NSString stringWithFormat:@"%i",_gateDownScore];
        //NSString *enenmyScore = [NSString stringWithFormat:@"%i",_gateUpScore];
        [[NSUserDefaults standardUserDefaults]setObject:@"none" forKey:@"myScore"];
        [[NSUserDefaults standardUserDefaults]setObject:@"none" forKey:@"enemyScore"];
       _internalCounter= 0;
        _gateUpScore = 0;
        _gateDownScore = 0;
        _maxGameTime = 60;
        
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
       // _soccer.physicsBody.usesPreciseCollisionDetection =  YES;
        // 3
        _soccer.physicsBody.friction = 0.2f;
        // 4
        _soccer.physicsBody.restitution = 1.0f;
        // 5
        _soccer.physicsBody.linearDamping = 0.2f;
        // 6
        _soccer.physicsBody.allowsRotation = YES;
        //7
        _soccer.physicsBody.mass = 10;
        
        
        
        
        
        
        // make physicsBody static
        //////////////////_player1.physicsBody.dynamic = NO;
        // make physicsBody static
        //////////////////// _player2.physicsBody.dynamic = NO;
        
        _player2 = [[SKSpriteNode alloc] initWithImageNamed: @"player2.png"];
        _player2.name = player2CategoryName;
        _player2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100);
        [self addChild:_player2];
        _player2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player2.frame.size];
        _player2.physicsBody.restitution = 0.0f;
        _player2.physicsBody.friction = 0.1f;
        _player2.physicsBody.allowsRotation = NO;
        _player2.physicsBody.mass = 100;
        
         // ADD GATE down
        _gateUp = [[SKSpriteNode alloc] initWithImageNamed: @"Gate_down_normal.png"];
        _gateUp.position = CGPointMake(screenWidth/2,40);
        _gateUp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gateUp.frame.size];
        _gateUp.name = gateUpCategoryName;
        [self addChild:_gateUp];
        
        
        // ADD GATE up
        _gateDown = [[SKSpriteNode alloc] initWithImageNamed: @"Gate_UP_normal.png"];
        _gateDown.position = CGPointMake(screenWidth/2,screenHeight - 40);
        _gateDown.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gateDown.frame.size];
        _gateDown.name = gateDownCategoryName;
        [self addChild:_gateDown];
        
        _gateUp.physicsBody.dynamic = NO;
        _gateDown.physicsBody.dynamic = NO;
      
        
//        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
//        SKNode* bottom = [SKNode node];
//        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
//        [self addChild:bottom];
        
        
        CGRect borderRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        SKNode* border = [SKNode node];

        border.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
        [self addChild:border];
        
        border.physicsBody.categoryBitMask = borderCategory;
        _soccer.physicsBody.categoryBitMask = soccerCategory;
        _player1.physicsBody.categoryBitMask = player1Category;
        _player2.physicsBody.categoryBitMask = player2Category;
        _gateUp.physicsBody.categoryBitMask = gateUpCategory;
        _gateDown.physicsBody.categoryBitMask = gateDownCategory;
        _aiKeeper.physicsBody.categoryBitMask = aiKeeperCategory;
        _aiForward.physicsBody.categoryBitMask = aiForwardCategory;
        
        _soccer.physicsBody.contactTestBitMask = borderCategory | player1Category|player2Category|gateUpCategory|gateDownCategory|aiForwardCategory|aiKeeperCategory;
        
        _player2.physicsBody.contactTestBitMask = redMushroomCategory | greenMushroomCategory;
        _greenMushroom.physicsBody.contactTestBitMask = borderCategory|player2Category;
        border.physicsBody.contactTestBitMask = player2Category|greenMushroomCategory|redMushroomCategory;
        _redMushroom.physicsBody.contactTestBitMask = borderCategory|player2Category;
        
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
        
        
        [self CallingAiGateKeeper];
        [self CallingAiGateForward];
        [self dropingMushroom];
        [self CallingMyGateKeeper];
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
        _soccer.physicsBody.velocity = CGVectorMake(secondBody.velocity.dx*10, secondBody.velocity.dy*10);
        _player1.physicsBody.velocity = CGVectorMake(0,0);

    }
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == player2Category) {
        _soccer.physicsBody.velocity = CGVectorMake(secondBody.velocity.dx*10, secondBody.velocity.dy*10);
        _player2.physicsBody.velocity = CGVectorMake(0,0);

    }

    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == gateUpCategory) {
        NSLog(@"gateupsoring");
        _gateUpScore++;
        [self alertStatus:@"soring" :@"Notice" :0];
        [_soccer runAction:[SKAction moveTo:CGPointMake(screenWidth/2, screenHeight/2) duration:1]];
        [_player2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100) duration:1]];
        [_aiForward runAction:[SKAction moveTo:CGPointMake(screenWidth/2, self.frame.size.height/2 + 100)duration:1]];
        [self runAction:[SKAction playSoundFileNamed:@"explosion_large.caf" waitForCompletion:NO]];


    }
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == gateDownCategory) {
        NSLog(@"gatedownsoring");
        _gateDownScore++;
        [self alertStatus:@"soring" :@"Notice" :0];
        [_soccer runAction:[SKAction moveTo:CGPointMake(screenWidth/2, screenHeight/2) duration:1]];
        [_player2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100) duration:1]];
        [_aiForward runAction:[SKAction moveTo:CGPointMake(screenWidth/2, self.frame.size.height/2 + 100)duration:1]];
        [self runAction:[SKAction playSoundFileNamed:@"explosion_large.caf" waitForCompletion:NO]];


    }
    
    if (firstBody.categoryBitMask == borderCategory && secondBody.categoryBitMask == greenMushroomCategory ) {
        NSLog(@"greenMushroom BORDER");
        //[_greenMushroom runAction:[SKAction removeFromParent]];
        [secondBody.node removeFromParent];

    }
    
    if (firstBody.categoryBitMask == borderCategory && secondBody.categoryBitMask == redMushroomCategory ) {
        NSLog(@"redMushroom  BORDER");
        //[_greenMushroom runAction:[SKAction removeFromParent]];
        [secondBody.node removeFromParent];
        
    }
    
    if (firstBody.categoryBitMask == player2Category && secondBody.categoryBitMask == greenMushroomCategory ) {
         NSLog(@"greenMushroom");
        //[_greenMushroom runAction:[SKAction removeFromParent]];
        [secondBody.node removeFromParent];
        [_gateDown removeFromParent];
        _gateDown = [[SKSpriteNode alloc] initWithImageNamed: @"Gate_UP_large.png"];
        _gateDown.position = CGPointMake(screenWidth/2+10,screenHeight-40);
        _gateDown.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gateDown.frame.size];
        _gateDown.name = gateDownCategoryName;
        _gateDown.physicsBody.dynamic = NO;
        _gateUp.physicsBody.categoryBitMask = gateUpCategory;
        _gateDown.physicsBody.categoryBitMask = gateDownCategory;
        [self addChild:_gateDown];
        
        _isEatingGreen = TRUE;
        eatGreenTime = CACurrentMediaTime();
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];


    }
    
    if (firstBody.categoryBitMask == player2Category && secondBody.categoryBitMask == redMushroomCategory ) {
         NSLog(@"redMushroom");
        [secondBody.node removeFromParent];
        _isEatingRed = true;
        eatRedTime = CACurrentMediaTime();
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];

    }
    
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == borderCategory) {
        NSLog(@"borderSoccer");
        [self alertStatus:@"out-of-bounds" :@"Notice" :0];
        [_soccer runAction:[SKAction moveTo:CGPointMake(screenWidth/2, screenHeight/2) duration:1]];
        [_player2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100) duration:1]];
        [_aiForward runAction:[SKAction moveTo:CGPointMake(screenWidth/2, self.frame.size.height/2 + 100)duration:1]];
        [self runAction:[SKAction playSoundFileNamed:@"explosion_large.caf" waitForCompletion:NO]];

    }
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask== aiForwardCategory ) {
        NSLog(@"aiForward-soccer");
        _soccer.physicsBody.velocity = CGVectorMake(secondBody.velocity.dx*10, secondBody.velocity.dy*10);
    }
    
}

- (void) setEatingGreenBOOL{
    if( !eatGreenTime==0 &&CACurrentMediaTime()-eatGreenTime > 5 && _isEatingGreen){
        _isEatingGreen = false;
        [_gateDown removeFromParent];
        [_gateDown removeFromParent];
        _gateDown = [[SKSpriteNode alloc] initWithImageNamed: @"Gate_UP_normal.png"];
        _gateDown.position = CGPointMake(screenWidth/2,screenHeight-40);
        _gateDown.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gateDown.frame.size];
        _gateDown.name = gateDownCategoryName;
        _gateDown.physicsBody.categoryBitMask =gateDownCategory;
        _gateDown.physicsBody.dynamic = NO;
        [self addChild:_gateDown];

    }
}



- (void) setEatingRedBOOL{
    if( !eatRedTime==0 &&CACurrentMediaTime()-eatRedTime > 5){
        _isEatingRed = false;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    /* Called before each frame is rendered */
    static int maxSpeed = 20;
    float speed = sqrt(_soccer.physicsBody.velocity.dx *_soccer.physicsBody.velocity.dx + _soccer.physicsBody.velocity.dy * _soccer.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        _soccer.physicsBody.linearDamping = 1.0f;
    } else {
        _soccer.physicsBody.linearDamping = 0.4f;
    }
  
   // CGPoint newPositionSoccer = CGPointMake(_soccer.position.x+2, _soccer.position.y+2);
   // _soccer.position = newPositionSoccer;
    
    
    //////////////////////////aiforward
    ///////////////////////////
   if(!_isEatingRed) {
       CGPoint moving = CGPointMake(_soccer.position.x - _aiForward.position.x, _soccer.position.y - _aiForward.position.y);
       SKAction *offensive = [SKAction moveTo:CGPointMake(_soccer.position.x, _soccer.position.y) duration:3];
       [_aiForward runAction:[SKAction repeatActionForever:offensive]];
        _aiForward.physicsBody.velocity  = CGVectorMake(moving.x, moving.y);
   }
    if(_isEatingRed){
        CGPoint moving = CGPointMake(_soccer.position.x - _aiForward.position.x, _soccer.position.y - _aiForward.position.y);
        SKAction *offensive = [SKAction moveTo:CGPointMake(_soccer.position.x, _soccer.position.y) duration:30];
        [_aiForward runAction:[SKAction repeatActionForever:offensive]];
        _aiForward.physicsBody.velocity  = CGVectorMake(moving.x, moving.y);
    }
    
    
    endTime = currentTime;
   _internalCounter= (endTime - startTime);
    if(_maxGameTime - _internalCounter>0)
        {  //if counting down to 0 show counter
            _internal.text = [NSString stringWithFormat:@"%i           %i : %i", _maxGameTime -_internalCounter,_gateDownScore,_gateUpScore];
        }
   
    else{
        NSString *myScore = [NSString stringWithFormat:@"%i",_gateDownScore];
        NSString *enenmyScore = [NSString stringWithFormat:@"%i",_gateUpScore];
        _internal.text = [NSString stringWithFormat:@"Game over, please check result."];
        [[NSUserDefaults standardUserDefaults]setObject:myScore forKey:@"myScore"];
        [[NSUserDefaults standardUserDefaults]setObject:enenmyScore forKey:@"enemyScore"];
        //[self removeFromParent]
        [_soccer removeFromParent];
        [_player2 removeFromParent];
        [_aiKeeper removeFromParent];
        [_aiForward removeFromParent];
        [_myKeeper removeFromParent];
        [_redMushroom removeFromParent];
        [_greenMushroom removeFromParent];
    }
    
    [self setEatingGreenBOOL];
    [self setEatingRedBOOL];
}




// AI gate keeper
- (void) CallingAiGateKeeper{
    //loading aiKeeper,2
    _aiKeeper = [SKSpriteNode spriteNodeWithImageNamed:@"gateKeeper"];
    _aiKeeper.position = CGPointMake(screenWidth/2, 900);
    _aiKeeper.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_aiKeeper.frame.size];
    CGMutablePathRef cgpath = CGPathCreateMutable();
    CGPoint start = CGPointMake(_aiKeeper.position.x, _aiKeeper.position.y);
    CGPoint end = CGPointMake(screenWidth/2+150, _aiKeeper.position.y);
    CGPoint path1 = CGPointMake(screenWidth/2 -150, _aiKeeper.position.y);
    CGPoint path2 = CGPointMake(_aiKeeper.position.x, _aiKeeper.position.y);
    CGPathMoveToPoint(cgpath,NULL, start.x, start.y);
    CGPathAddCurveToPoint(cgpath, NULL, path1.x, path1.y, path2.x, path2.y, end.x, end.y);
    SKAction *defend = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:4];
    _aiKeeper.physicsBody.dynamic = NO;
    _aiKeeper.physicsBody.allowsRotation = NO;

    [self addChild:_aiKeeper];
    [_aiKeeper runAction:[SKAction repeatActionForever:(defend)]];
    
}

// Ai Forward
- (void) CallingAiGateForward{
    //loading aiKeeper,2
    _aiForward = [SKSpriteNode spriteNodeWithImageNamed:@"gateForward"];
    _aiForward.position = CGPointMake(screenWidth/2, self.frame.size.height/2 + 100);
    _aiForward.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_aiForward.frame.size];
    _aiForward.physicsBody.allowsRotation = NO;
    _aiForward.physicsBody.dynamic = NO;
    [self addChild:_aiForward];
   
}

- (void) CallingGreenMushroom{
    _greenMushroom = [SKSpriteNode spriteNodeWithImageNamed:@"greenMushroom"];
    int randomNumber = [self getRandomNumberBetween:20 to:screenWidth/2-150];
    _greenMushroom.position = CGPointMake((randomNumber),screenHeight-_greenMushroom.size.height);
    _greenMushroom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_greenMushroom.frame.size];
    _greenMushroom.physicsBody.allowsRotation = NO;
    _greenMushroom.physicsBody.velocity = CGVectorMake(0, -200);
    _greenMushroom.physicsBody.categoryBitMask = greenMushroomCategory;
    //_greenMushroom.physicsBody.dynamic = NO;
    [self addChild:_greenMushroom];
}

- (void) CallingRedMushroom{
    _redMushroom = [SKSpriteNode spriteNodeWithImageNamed:@"redMushroom"];
    int randomNumber = [self getRandomNumberBetween:screenWidth/2+150 to:screenWidth-20];
    _redMushroom.position = CGPointMake((randomNumber),screenHeight-_redMushroom.size.height);
    _redMushroom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_redMushroom.frame.size];
    _redMushroom.physicsBody.allowsRotation = NO;
    _redMushroom.physicsBody.velocity = CGVectorMake(0, -200);
    _redMushroom.physicsBody.categoryBitMask = redMushroomCategory;
    //_greenMushroom.physicsBody.dynamic = NO;
    [self addChild:_redMushroom];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (void) dropingMushroom
{
    NSThread *ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
}

- (void) run{
    while (true){
        int randomInt = [self getRandomNumberBetween:0 to:1];
        if(randomInt==0)[self CallingGreenMushroom];
        if(randomInt==1) [self CallingRedMushroom];
        [NSThread sleepForTimeInterval:[self getRandomNumberBetween:5 to:10]];
        [self runAction:[SKAction playSoundFileNamed:@"powerup.caf" waitForCompletion:NO]];

       
    }
}

- (void) showingScoringLabel{
    _scoringLabel = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    //_scoringLabel.position = CGPointMake(CGRectGetMidX(self.frame)/2, CGRectGetMinY(self.frame)/2);
    _scoringLabel.position = CGPointMake(screenWidth/2 - 200, screenHeight/2);
    _scoringLabel.fontColor = [SKColor blueColor];
    _scoringLabel.fontSize = 100;
    _scoringLabel.name = scroingLableCategoryName;
    _scoringLabel.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_scoringLabel.frame.size];
    _scoringLabel.text = [NSString stringWithFormat:@"scoring!!!"];
    _scoringLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoringLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    [self addChild:_scoringLabel];}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (void) addPlayer{
    _player1 = [[SKSpriteNode alloc] initWithImageNamed: @"player1.png"];
    _player1.name = player1CategoryName;
    _player1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    [self addChild:_player1];
    _player1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player1.frame.size];
    _player1.physicsBody.restitution = 0.0f;
    _player1.physicsBody.friction = 0.1f;
    _player1.physicsBody.allowsRotation = NO;
    _player1.physicsBody.mass = 100;
}

- (void) CallingMyGateKeeper{
    _myKeeper  = [SKSpriteNode spriteNodeWithImageNamed:@"MyKeeper"];
    _myKeeper.position = CGPointMake(screenWidth/2, 100);
    _myKeeper.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_aiKeeper.frame.size];
    CGMutablePathRef cgpath = CGPathCreateMutable();
    CGPoint start = CGPointMake(_myKeeper.position.x, _myKeeper.position.y);
    CGPoint end = CGPointMake(screenWidth/2+150, _myKeeper.position.y);
    CGPoint path1 = CGPointMake(screenWidth/2 -160, _myKeeper.position.y);
    CGPoint path2 = CGPointMake(_myKeeper.position.x, _myKeeper.position.y);
    CGPathMoveToPoint(cgpath,NULL, start.x, start.y);
    CGPathAddCurveToPoint(cgpath, NULL, path1.x, path1.y, path2.x, path2.y, end.x, end.y);
    SKAction *defend = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:2];
    _myKeeper.physicsBody.dynamic = NO;
    _myKeeper.physicsBody.allowsRotation = NO;
    
    [self addChild:_myKeeper];
    [_myKeeper runAction:[SKAction repeatActionForever:(defend)]];
    
}

@end
