//
//  ViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Köhler on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "ViewController.h"
#import "BreakoutGameScene.h"

@implementation ViewController


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //[_results setObject:@"" forKey:@"myScore"];
    //[_results setObject:@"" forKey:@"enemyScore"];
    
    // Configure the view.
    _skView = (SKView *)self.view;
    if (!_skView.scene) {
        _skView.showsFPS = YES;
        _skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [BreakoutGameScene sceneWithSize:_skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [_skView presentScene:scene];
        
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
