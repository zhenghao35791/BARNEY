//
//  MyScene.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Reichart on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
/////
#import <UIKit/UIKit.h>
#import "BreakoutGameSceneNet.h"
#import "Player.h"
#import "GameOverViewController.h"
#import "GameOutcomeQueue.h"
#import "GameIncomeQueue.h"
//#import "Level1ViewController.h"


static NSString* soccerCategoryName = @"soccer";
static NSString* player1CategoryName = @"player1";///////////////////////
static NSString* player2CategoryName = @"player2";////////////////////////
static NSString* gateUpCategoryName = @"gateUpCategoryName";
static NSString* gateDownCategoryName = @"gateDownCategoryName";
static NSString* aiKeeperCategoryName = @"aiKeeperCategoryName";
static NSString* scroingLableCategoryName = @"scroingLableCategoryName";
static NSString* localName;
static NSInteger sendPacketCount=0;
static NSInteger soccerPacketCount=0;


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





@interface BreakoutGameSceneNet()

@property (nonatomic) BOOL isFingerOnPlayer1;
@property (nonatomic) BOOL isFingerOnPlayer2;
@property (nonatomic) BOOL is5Times;
@property (nonatomic) NSTimeInterval startTime1;
@property (nonatomic) NSTimeInterval endTime1;
@property (nonatomic) NSTimeInterval eatGreenTime1;
@property (nonatomic) NSTimeInterval eatRedTime1;
@property (nonatomic) bool isServer;

@end


@implementation BreakoutGameSceneNet



+ (id)sceneWithSize:(CGSize)size isServer:(BOOL)isServer initName: (NSString *)name
{
    return [[BreakoutGameSceneNet alloc] initWithSize:size isServer:isServer initName:name];
}


-(id)initWithSize:(CGSize)size isServer:(BOOL)isServer initName: (NSString *)name{
    if (self = [super initWithSize:size]) {
        _isServer = isServer;
        NSLog(@"Player name %@", name);
        localName = name;
        
        
        _eatGreenTime1 = 0;
        _eatRedTime1 = 0;
        _maxGameTime = 60;
        _gateDownScore = 0;
        _gateUpScore = 0;
        _internalCounter= 0;
        _isEatingGreen1 = FALSE;
        _isEatingRed1 = FALSE;
        _is5Times = false;

        _isEatingGreen1 = FALSE;
        _isEatingRed1 = FALSE;
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
        _greenMushroom.physicsBody.contactTestBitMask = borderCategory|player2Category|player1Category;
        border.physicsBody.contactTestBitMask = player2Category|greenMushroomCategory|redMushroomCategory|player2Category ;
        _redMushroom.physicsBody.contactTestBitMask = borderCategory|player2Category|player1Category;
        
        self.physicsWorld.contactDelegate = self;
        
        _startTime1 = CACurrentMediaTime();
        
        
        //loading internal
        _internal = [SKLabelNode labelNodeWithFontNamed:@"internalTime"];
        _internal.fontSize = 40;
        _internal.position = CGPointMake(screenWidth-200, screenHeight-50);
        _internal.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter; //good for positioning with other sprites
        _internal.fontColor = [SKColor whiteColor ];
        _internal.name = @"countDown";
        [self addChild:_internal];
        
        
       // [self CallingAiGateKeeper];
        //[self CallingAiGateForward];
        //[self dropingMushroom];
        //[self CallingMyGateKeeper];
        [self addPlayer1];
        [self addPlayer2];
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
   //////if is server, control player1
    if(_isServer&&[[_selectedNode name] isEqualToString:player1CategoryName]) {
        sendPacketCount ++;
        
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _player1.physicsBody.velocity = CGVectorMake(translation.x, translation.y);//speed
        if(sendPacketCount%3 ==0)
        {
            Player *player1 = [[Player alloc] initWithPostion:_player1.position.x positionY:_player1.position.y];
            player1.name = player1CategoryName;
            [GameOutcomeQueue addContent:player1];
        }

        
    }
    // if isnot server, control player2
    if(!_isServer&&[[_selectedNode name] isEqualToString:player2CategoryName]) {
        sendPacketCount ++;
        
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _player2.physicsBody.velocity = CGVectorMake(translation.x, translation.y);//speed
        if(sendPacketCount%3 ==0)
        {
            Player *player2 = [[Player alloc] initWithPostion:_player2.position.x positionY:_player2.position.y];
            player2.name = player2CategoryName;
            [GameOutcomeQueue addContent:player2];
        }

    }
    

    [GameOutcomeQueue addCount];
    
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
        Player *soccer = [[Player alloc] initWithPostion:_soccer.position.x positionY:_soccer.position.y];
        soccer.name = soccerCategoryName;
        [GameOutcomeQueue addContent:soccer];
        
    }
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == player2Category) {
        _soccer.physicsBody.velocity = CGVectorMake(secondBody.velocity.dx*10, secondBody.velocity.dy*10);
        _player2.physicsBody.velocity = CGVectorMake(0,0);
        Player *soccer = [[Player alloc] initWithPostion:_soccer.position.x positionY:_soccer.position.y];
        soccer.name = soccerCategoryName;
        [GameOutcomeQueue addContent:soccer];
        
    }
    
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == gateUpCategory) {
        NSLog(@"gateupsoring");
        _gateUpScore++;
        Player *gateUpScore = [[Player alloc] initWithPostion:_gateUpScore positionY:_gateDownScore];
        gateUpScore.name = @"gateScore";
        [GameOutcomeQueue addContent:gateUpScore];

        [self alertStatus:@"soring" :@"Notice" :0];
        [_soccer runAction:[SKAction moveTo:CGPointMake(screenWidth/2, screenHeight/2) duration:1]];
        [_player2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100) duration:1]];
       // [_aiForward runAction:[SKAction moveTo:CGPointMake(screenWidth/2, self.frame.size.height/2 + 100)duration:1]];
        [self runAction:[SKAction playSoundFileNamed:@"explosion_large.caf" waitForCompletion:NO]];

        
    }
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == gateDownCategory) {
        NSLog(@"gatedownsoring");
        _gateDownScore++;
        Player *gateDownScore = [[Player alloc] initWithPostion:_gateUpScore positionY:_gateDownScore];
        gateDownScore.name = @"gateScore";
        [GameOutcomeQueue addContent:gateDownScore];
        
        [self alertStatus:@"soring" :@"Notice" :0];
        [_soccer runAction:[SKAction moveTo:CGPointMake(screenWidth/2, screenHeight/2) duration:1]];
        [_player2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100) duration:1]];
       // [_aiForward runAction:[SKAction moveTo:CGPointMake(screenWidth/2, self.frame.size.height/2 + 100)duration:1]];
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
        
        _isEatingGreen1 = true;
        _eatGreenTime1 = CACurrentMediaTime();
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];

    }
    
    if (firstBody.categoryBitMask == player2Category && secondBody.categoryBitMask == redMushroomCategory ) {
        NSLog(@"redMushroom");
        [secondBody.node removeFromParent];
        _isEatingRed1 = true;
        _eatRedTime1 = CACurrentMediaTime();
        [self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];

    }
    
    
    if (firstBody.categoryBitMask == soccerCategory && secondBody.categoryBitMask == borderCategory) {
        NSLog(@"borderSoccer");
        [self alertStatus:@"out-of-bounds" :@"Notice" :0];
        [_soccer runAction:[SKAction moveTo:CGPointMake(screenWidth/2, screenHeight/2) duration:1]];
        [_player2 runAction:[SKAction moveTo:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100) duration:1]];
        //[_aiForward runAction:[SKAction moveTo:CGPointMake(screenWidth/2, self.frame.size.height/2 + 100)duration:1]];
        [self runAction:[SKAction playSoundFileNamed:@"explosion_large.caf" waitForCompletion:NO]];

    }
    
}

- (void) setEatingGreenBOOL{
    if( !_eatGreenTime1==0 &&CACurrentMediaTime()-_eatGreenTime1 > 5 && _isEatingGreen1){
        _isEatingGreen1 = false;
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
    if( !_eatRedTime1==0 &&CACurrentMediaTime()-_eatRedTime1 > 5){
        _isEatingRed1 = false;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    Player *tmpPlayer;
    if([GameIncomeQueue count] > 0)
    {
        tmpPlayer = [GameIncomeQueue dequeue];
        
        NSLog(@"new player postion %@", tmpPlayer);
        
        if(tmpPlayer.name != nil)
        {
            if([tmpPlayer.name isEqualToString:soccerCategoryName])
            {
                [_soccer setPosition:CGPointMake(tmpPlayer.positionX, tmpPlayer.positionY)];
            }
            else if([tmpPlayer.name isEqualToString:@"gateScore"])
            {
                _gateUpScore = (int)tmpPlayer.positionX;
                _gateDownScore = (int)tmpPlayer.positionY;
            }
            else
            {
                if(_isServer)
                {
                    if([tmpPlayer.name isEqualToString:_player2.name])
                    {
                        [_player2 setPosition:CGPointMake(tmpPlayer.positionX, tmpPlayer.positionY)];
                    }
                
                }
                else
                {
                    if([tmpPlayer.name isEqualToString:_player1.name])
                    {
                        [_player1 setPosition:CGPointMake(tmpPlayer.positionX, tmpPlayer.positionY)];
                    }
                }
            }
            
            
        }
        
    }

    
    /* Called before each frame is rendered */
    static int maxSpeed = 20;
    float speed = sqrt(_soccer.physicsBody.velocity.dx *_soccer.physicsBody.velocity.dx + _soccer.physicsBody.velocity.dy * _soccer.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        _soccer.physicsBody.linearDamping = 1.0f;
    } else {
        _soccer.physicsBody.linearDamping = 0.4f;
    }
    
    _endTime1 = currentTime;
    _internalCounter= (_endTime1 - _startTime1);
    if(_maxGameTime -_internalCounter>0)
    {  //if counting down to 0 show counter
        _internal.text = [NSString stringWithFormat:@"%li           %i : %i",
                          _maxGameTime -_internalCounter,_gateDownScore,_gateUpScore];
    }
    
    else{
        
        _internal.text = [NSString stringWithFormat:@"Game over, please check result."];
        if(_isServer)
        {
            NSString *myScore = [NSString stringWithFormat:@"%i",_gateDownScore];
            NSString *enenmyScore = [NSString stringWithFormat:@"%i",_gateUpScore];
            [[NSUserDefaults standardUserDefaults]setObject:myScore forKey:@"myScore"];
            [[NSUserDefaults standardUserDefaults]setObject:enenmyScore forKey:@"enemyScore"];
        }
        else
        {
            NSString *myScore = [NSString stringWithFormat:@"%i",_gateUpScore];
            NSString *enenmyScore = [NSString stringWithFormat:@"%i",_gateDownScore];
            [[NSUserDefaults standardUserDefaults]setObject:myScore forKey:@"myScore"];
            [[NSUserDefaults standardUserDefaults]setObject:enenmyScore forKey:@"enemyScore"];

        }
        //[self removeFromParent]
        [_soccer removeFromParent];
        [_player2 removeFromParent];
        [_aiKeeper removeFromParent];
        //[_aiForward removeFromParent];
        [_myKeeper removeFromParent];
        [_redMushroom removeFromParent];
        [_greenMushroom removeFromParent];
    }
    
    [self setEatingGreenBOOL];
    [self setEatingRedBOOL];
    
    if(soccerPacketCount %3 ==0)
    {
        Player *soccer = [[Player alloc] initWithPostion:_soccer.position.x positionY:_soccer.position.y];
        soccer.name = soccerCategoryName;
        [GameOutcomeQueue addContent:soccer];
    }
    soccerPacketCount ++;
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

- (void) addPlayer1{
    _player1 = [[SKSpriteNode alloc] initWithImageNamed: @"gateForward.png"];
    _player1.name = player1CategoryName;
    _player1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 200);
    [self addChild:_player1];
    _player1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player1.frame.size];
    _player1.physicsBody.restitution = 0.0f;
    _player1.physicsBody.friction = 0.1f;
    _player1.physicsBody.allowsRotation = NO;
    _player1.physicsBody.mass = 100;
    _player1.physicsBody.categoryBitMask = player1Category;
}

- (void) addPlayer2{
    _player2 = [[SKSpriteNode alloc] initWithImageNamed: @"player2.png"];
    _player2.name = player2CategoryName;
    _player2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 100);
    [self addChild:_player2];
    _player2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player2.frame.size];
    _player2.physicsBody.restitution = 0.0f;
    _player2.physicsBody.friction = 0.1f;
    _player2.physicsBody.allowsRotation = NO;
    _player2.physicsBody.mass = 100;
    _player2.physicsBody.categoryBitMask = player2Category;

}


@end
