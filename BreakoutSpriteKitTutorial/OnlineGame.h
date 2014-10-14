#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Game.h"
//static const uint32_t soccerCategory = 0x1 << 0;
//static const uint32_t playerCategory = 0x1 << 1;

static const uint8_t player1Category = 1;
static const uint8_t player2Category = 2;
static const uint8_t soccerCategory = 3;

@class OnlineGame;
//@protocol GameViewControllerDelegate <NSObject>
//
//- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason;

//@end

@interface OnlineGame : SKScene<UIAccelerometerDelegate, SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    CGFloat player1Direction;
    CGFloat player2Direction;
    CGPoint startLocation;
    CGPoint newLocation;
    double currentMaxX;
    double currentMaxY;
    
    
}

//@property (nonatomic, weak) id <GameViewControllerDelegate> delegate;
//@property (nonatomic, strong) Game *game;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property SKSpriteNode *player1;
@property SKSpriteNode *player2;
@property SKSpriteNode *soccer;
@property SKSpriteNode *enemyplayer;
@property SKSpriteNode *propeller;
@property SKSpriteNode *selectedNode;
@property SKSpriteNode *background;
@end
