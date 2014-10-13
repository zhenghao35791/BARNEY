//
//  ViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Barbara Köhler on 10/2/13.
//  Copyright (c) 2013 Barbara Köhler. All rights reserved.
//

#import "ViewController.h"
#import "BreakoutGameScene.h"
#import "BreakoutGameScene1.h"

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //SKView * skView = (SKView *)self.view;
//}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //[_results setObject:@"" forKey:@"myScore"];
    //[_results setObject:@"" forKey:@"enemyScore"];
    
    // Configure the view.
   // NSLog(@"test1");
    SKView * skView = (SKView *)self.view;
    NSLog(@"skView.class:%@",skView.class);
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
         NSString *model = [[NSUserDefaults standardUserDefaults]objectForKey:@"model"];
        // Create and configure the scene.
      //  NSLog(@"test3");
        SKScene * scene;
        if([model isEqualToString:@"level1"])
            scene = [BreakoutGameScene1 sceneWithSize:skView.bounds.size];
        if([model isEqualToString:@"level2"])
            scene = [BreakoutGameScene sceneWithSize:skView.bounds.size];
        if([model isEqualToString:@"level3"])
            scene = [BreakoutGameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        //NSLog(@"test4");
        // Present the scene.
        [skView presentScene:scene];
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
