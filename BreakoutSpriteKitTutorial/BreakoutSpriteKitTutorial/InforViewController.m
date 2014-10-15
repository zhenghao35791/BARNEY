//
//  InforViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-13.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import "InforViewController.h"

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
        self.helperText.text = @"single game info";
        self.helperText.editable = NO;
    }
    if([from_Info isEqualToString:@"home"]){
        self.helperText.editable = YES;
        self.helperText.font = [UIFont fontWithName:@"Arial" size:40];
        //self.helperText.editable = NO;
        self.helperText.text = @"any game info";
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
        [self performSegueWithIdentifier:@"info_2_home" sender:self];//page nivagation
}
@end
