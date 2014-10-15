//
//  ViewController1.m
//  Soccer
//
//  Created by Finguitar on 7/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "GameViewController.h"
#import "GameOverViewController.h"
#import "BreakoutGameSceneNet.h"

@implementation GameViewController
@synthesize delegate = _delegate;
@synthesize game = _game;

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([[segue identifier] isEqualToString:@"finish_game_segue"]){
//        GameOverViewController *detailViewController = [segue destinationViewController];
//        detailViewController.score = @"3";
//    }
}

//=======only for test



- (IBAction)go2Result:(id)sender {
    //finish_game_segue
    [self performSegueWithIdentifier:@"finish_game_segue" sender:self];//page nivagation
}


- (IBAction)exitAction:(id)sender
{
    [self.game quitGameWithReason:QuitReasonUserQuit];
}

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
    [self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)gameWaitingForServerReady:(Game *)game
{
    NSLog(@"client waits for server");
    //	self.centerLabel.text = NSLocalizedString(@"Waiting for game to start...", @"Status text: waiting for server");
}

- (void)gameWaitingForClientsReady:(Game *)game
{
    NSLog(@"server waits for client");
    //    self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

- (void)gameDidBegin:(Game *)game isServer:(BOOL)isServer localName:(NSString *)name
{
//        // Configure the view.
//    SKView * skView = (SKView *)self.view;
//    if (!skView.scene)
//    {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
//        
//        // Create and configure the scene.
//        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
//        
//        // Present the scene.
//        [skView presentScene:scene];
//    }
    
    SKView * skView = (SKView *)self.view;
    NSLog(@"skView.class:%@",skView.class);
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        //NSString *model = [[NSUserDefaults standardUserDefaults]objectForKey:@"model"];
        // Create and configure the scene.
        //  NSLog(@"test3");
        SKScene * scene;
        scene = [BreakoutGameSceneNet sceneWithSize:skView.bounds.size isServer:isServer initName:name ];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        //NSLog(@"test4");
        // Present the scene.
        [skView presentScene:scene];
    }

    
    
    self.backGroundImage.hidden = YES;
    self.waitingLabel.hidden = YES;
}

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer
{
   // [self hidePlayerLabelsForPlayer:disconnectedPlayer];
    
}


- (IBAction)getResult:(id)sender {
    //multiP_result
    [self performSegueWithIdentifier:@"multiP_result" sender:self];//page nivagation
}
@end
