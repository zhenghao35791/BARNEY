//
//  InforViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-13.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import "InforViewController.h"
#import "MainViewController.h"

@interface InforViewController ()

@end

@implementation InforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *from_Info = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoFrom"];
    //[self.helperText setFont:[UIFont fontWithName:@"Arial" size:40]];
    // Do any additional setup after loading the view.
    if([from_Info isEqualToString:@"single"]){
        self.helperText.editable = YES;
        self.helperText.font = [UIFont fontWithName:@"Arial" size:40];
        //self.helperText.editable = NO;
        NSMutableString *scoreInfo = [[NSMutableString alloc] init];
        [scoreInfo appendString:@"Single Game Information"];
        [scoreInfo appendString:@"\n1.Please enter your name before playing, and kindly check your game state by clicking the “check” button."];
        [scoreInfo appendString:@"\n2.You can get access to level 1 at any circumstance."];
        [scoreInfo appendString:@"\n3.When you get more than 5 scores, level 2 will be unlocking"];
        [scoreInfo appendString:@"\n4.Similarly, 10 scores will unlock level 3s."];

        self.helperText.text = scoreInfo;
        self.helperText.editable = NO;
    }
    if([from_Info isEqualToString:@"home"]){
        self.helperText.editable = YES;
        self.helperText.font = [UIFont fontWithName:@"Arial" size:40];
        //self.helperText.editable = NO;
        NSMutableString *scoreInfo = [[NSMutableString alloc] init];
        [scoreInfo appendString:@"Game Information"];
        [scoreInfo appendString:@"\n1.To start multi-player game, players must be connect by a network such as wifi/blutooth."];
        [scoreInfo appendString:@"\n2.Player can host a game by clicking the “Host Game”. If the host see any one join its game, he can start the game by click the “start” button."];
        [scoreInfo appendString:@"\n3.To join a Game, players can click “Join Game” button to check who is hosting a game. If there is any game that is waiting for users to join, he can join the game directly by tap the host user name to join it."];
        
        self.helperText.text = scoreInfo;
        self.helperText.editable = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickBack:(id)sender {
    
    NSString *from_Info = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoFrom"];
    // Do any additional setup after loading the view.
    if([from_Info isEqualToString:@"single"])
        [self performSegueWithIdentifier:@"info_2_single_home" sender:self];//page nivagation
    if([from_Info isEqualToString:@"home"])
    {
        
            MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self presentViewController:controller animated:YES completion:nil];
    }
}
@end
