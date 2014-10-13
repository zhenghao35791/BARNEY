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

- (IBAction)clickBack:(id)sender {
    
     [self performSegueWithIdentifier:@"info_2_single_home" sender:self];//page nivagation
}
@end
