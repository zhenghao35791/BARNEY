//
//  ViewController1.h
//  Soccer
//
//  Created by Finguitar on 7/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Game.h"


@class GameViewController;
@protocol GameViewControllerDelegate <NSObject>

- (void)gameViewController:(GameViewController *)controller didQuitWithReason:(QuitReason)reason;

@end

@interface GameViewController : UIViewController <UIAlertViewDelegate, GameDelegate>
@property (weak, nonatomic) IBOutlet UILabel *waitingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

@property (nonatomic, weak) id <GameViewControllerDelegate> delegate;
@property (nonatomic, strong) Game *game;
@end
