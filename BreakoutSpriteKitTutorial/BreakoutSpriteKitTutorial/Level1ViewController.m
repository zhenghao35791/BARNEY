//
//  Level1ViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-13.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import "Level1ViewController.h"

#import "BreakoutGameScene1.h"

@implementation Level1ViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //[_results setObject:@"" forKey:@"myScore"];
    //[_results setObject:@"" forKey:@"enemyScore"];
    
    // Configure the view.
    // NSLog(@"test1");
    SKView * skView1 = (SKView *)self.view;
    //NSLog(@"test2");
    if (!skView1.scene) {
        skView1.showsFPS = YES;
        skView1.showsNodeCount = YES;
        
        // Create and configure the scene.
        //  NSLog(@"test3");
        SKScene * scene = [BreakoutGameScene1 sceneWithSize:skView1.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        //NSLog(@"test4");
        // Present the scene.
        [skView1 presentScene:scene];
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

- (IBAction)results:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"level2" forKey:@"from_level"];
    [self performSegueWithIdentifier:@"single_game_over" sender:self];//page nivagation

}
@end
