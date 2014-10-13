//
//  WelcomeViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-13.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (IBAction)leve1Game:(id)sender {
    if([_userName.text isEqualToString:@""])
        [self alertStatus:@"Please set the player name" :@"Notice" :0];
    else{
        [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"userName"];
        [self performSegueWithIdentifier:@"game_level1" sender:self];//page nivagation
    }
}

- (IBAction)level2Game:(id)sender {
    if([_userName.text isEqualToString:@""])
        [self alertStatus:@"Please set the player name" :@"Notice" :0];
    else{
        [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"userName"];
        [self performSegueWithIdentifier:@"game_level2" sender:self];//page nivagation
    }
}

- (IBAction)level3Game:(id)sender {
    if([_userName.text isEqualToString:@""])
        [self alertStatus:@"Please set the player name" :@"Notice" :0];
    else{
        [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"userName"];
        [self performSegueWithIdentifier:@"game_level3" sender:self];//page nivagation
    }
}

- (IBAction)Quit:(id)sender {
    [self performSegueWithIdentifier:@"game_level2" sender:self];//page nivagation
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{//click on return to remove the keyboard
    [textField resignFirstResponder];
    return YES;
}

@end
