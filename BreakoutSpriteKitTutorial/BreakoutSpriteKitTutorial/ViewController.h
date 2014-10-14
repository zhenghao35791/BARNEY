//
//  ViewController.h
//  BreakoutSpriteKitTutorial
//

//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@import AVFoundation;

@interface ViewController : UIViewController
//@property SKView * skView;
- (IBAction)results:(id)sender;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;


@end
