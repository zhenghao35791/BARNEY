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
#import "BreakoutGameScene3.h"
#import <AVFoundation/AVFoundation.h>

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //SKView * skView = (SKView *)self.view;
//}
AVAudioPlayer * backgroundMusicPlayer;
NSURL *url;

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    ////////////////////loading background music
//    NSError *error;
//    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"newBackground" withExtension:@"caf"];
//    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
//    if([self.backgroundMusicPlayer isPlaying]){
//        [self.backgroundMusicPlayer stop];
//    }
//    else{
//        self.backgroundMusicPlayer.numberOfLoops = -1;
//        //[self.backgroundMusicPlayer prepareToPlay];
//        [self.backgroundMusicPlayer play];
//    }
    //AVAudioPlayer * backgroundMusicPlayer;
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newBackground" ofType:@"caf"]];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //[_aAudioPlayer stop];
    [backgroundMusicPlayer play];
    
    
    
    
    ////////////////////
    
    
    
    _skView = (SKView *)self.view;
    NSLog(@"skView.class:%@",_skView.class);
    if (!_skView.scene) {
        _skView.showsFPS = YES;
        _skView.showsNodeCount = YES;
         NSString *model = [[NSUserDefaults standardUserDefaults]objectForKey:@"model"];
        // Create and configure the scene.
      //  NSLog(@"test3");
        SKScene * scene;
        if([model isEqualToString:@"level1"])
            scene = [BreakoutGameScene1 sceneWithSize:_skView.bounds.size];
        if([model isEqualToString:@"level2"])
            scene = [BreakoutGameScene sceneWithSize:_skView.bounds.size];
        if([model isEqualToString:@"level3"])
            scene = [BreakoutGameScene3 sceneWithSize:_skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        //NSLog(@"test4");
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

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    _skView = nil;
}


- (IBAction)results:(id)sender {
    //[[NSUserDefaults standardUserDefaults]setObject:@"level2" forKey:@"from_level"];
    //[self performSegueWithIdentifier:@"single_game_over" sender:self];//page nivagation
    //if([self.backgroundMusicPlayer ]){
    [self viewDidDisappear:NO];
    [backgroundMusicPlayer stop];
    //url = nil;
    backgroundMusicPlayer = nil;
    url = nil;
    [self viewDidDisappear:NO];
    _skView = nil;
    

    
    //}
    [self performSegueWithIdentifier:@"single_game_over" sender:self];//page nivagation
    
}
@end
