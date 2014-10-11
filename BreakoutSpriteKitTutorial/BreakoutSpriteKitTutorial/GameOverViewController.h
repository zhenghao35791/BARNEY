//
//  GameOverViewController.h
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-11.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *currentScore;
@property (weak, nonatomic) IBOutlet UILabel *currentRanking;

@property (weak, nonatomic) IBOutlet UILabel *gameOverLable;
- (IBAction)clickHome:(id)sender;
- (IBAction)clickContinue:(id)sender;


@end
