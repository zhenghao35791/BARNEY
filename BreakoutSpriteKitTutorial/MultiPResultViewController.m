//
//  MultiPResultViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-15.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import "MultiPResultViewController.h"

@interface MultiPResultViewController ()

@end

@implementation MultiPResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *myScore = [[NSUserDefaults standardUserDefaults]objectForKey:@"myScore"];
    NSString *enemyScore = [[NSUserDefaults standardUserDefaults]objectForKey:@"enemyScore"];
    //NSString *result;
    //NSLog(@"result : %@",result);
    if([myScore integerValue]>[enemyScore integerValue]){
        //result = @"3";
        _alable.text = @"Congratulation";
    }
    if([myScore integerValue]==[enemyScore integerValue]){
        //result = @"1";
        _alable.text = @"Draw";
    }
    if([myScore integerValue]<[enemyScore integerValue]){
        //result = @"0";
        _alable.text = @"You lose the match";
    }
    //NSLog(@"result : %@",result);
    NSMutableString *scoreInfo = [[NSMutableString alloc] init];
    [scoreInfo appendString:myScore];
    [scoreInfo appendString:@" : "];
    [scoreInfo appendString:enemyScore];
    _theResult.text = scoreInfo;

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

- (IBAction)goHome:(id)sender {
    //multiP_result
    [self performSegueWithIdentifier:@"multiP_result" sender:self];//page nivagation

}
@end
