//
//  WelcomeViewController.m
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-13.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SystemSetting.h"
#import "MainViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _score = @"0";
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
        [[NSUserDefaults standardUserDefaults]setObject:@"level1" forKey:@"model"];
        [self performSegueWithIdentifier:@"game_segue" sender:self];//page nivagation
    }
}

- (IBAction)level2Game:(id)sender {
    if([_userName.text isEqualToString:@""])
        [self alertStatus:@"Please set the player name" :@"Notice" :0];
    else{
        if ([_score integerValue] < 5){
            [self alertStatus:@"You cannot play this" :@"Notice" :0];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:@"level2" forKey:@"model"];
            [self performSegueWithIdentifier:@"game_segue" sender:self];//page nivagation
        }
    }
}

- (IBAction)level3Game:(id)sender {
    if([_userName.text isEqualToString:@""])
        [self alertStatus:@"Please set the player name" :@"Notice" :0];
    else{
        if ([_score integerValue] < 10){
            [self alertStatus:@"You cannot play this" :@"Notice" :0];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:@"level3" forKey:@"model"];
            [self performSegueWithIdentifier:@"game_segue" sender:self];//page nivagation
        }
    }
}

- (IBAction)Quit:(id)sender {
    MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self presentViewController:controller animated:YES completion:nil];}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)checkScore:(id)sender {
    if([_userName.text isEqualToString:@""])
        [self alertStatus:@"Please set the player name" :@"Notice" :0];
    else{
        _score = [self getScoreBy:_userName.text];
        if([_score isEqualToString:@"ERROR"]){
            NSString *scoreInfo = @"connection failure.";
            _ScoreInformation.text = scoreInfo;
        }
        else{
            @try
            {
            NSLog(@"_score: %@",_score);
            NSMutableString *scoreInfo = [[NSMutableString alloc] init];;
            [scoreInfo appendString:@"Your score is "];
            
            [scoreInfo appendString:_score];
            NSLog(@"scoreInfo: %@",scoreInfo);
            if([_score integerValue]>=10){
                [scoreInfo appendString:@"; you can play all"];
                NSLog(@"scoreInfo: %@",scoreInfo);
            }
            else if([_score integerValue]>=5){
                [scoreInfo appendString:@"; you can play level1 and level2"];
                NSLog(@"scoreInfo: %@",scoreInfo);
            }
            else if([_score integerValue]<5){
                [scoreInfo appendString:@"; you can play only level1"];
                NSLog(@"scoreInfo: %@",scoreInfo);
            }
            NSLog(@"scoreInfo: %@",scoreInfo);
            NSLog(@"scoreInfo: %@",_ScoreInformation.text);
            _ScoreInformation.text = scoreInfo;
            NSLog(@"scoreInfo: %@",_ScoreInformation.text);
        }
            @catch (NSException *exception) {
                _ScoreInformation.text = @"connection failed";
                NSLog(@"Exception: %@", exception);
                [self alertStatus:@"connection failed" :@"Notice" :0];
                //sampleDetail.text = self.sampleDetailInit;
        }
                }
    }
}

-(NSString *) getScoreBy:(NSString *)username
{
    NSMutableDictionary *jsonData;
    NSString *score;
    @try {
        //username = [[AESCrypt encrypt:username password:KEY] urlEncode];
        NSString *post = [[NSString alloc] initWithFormat:@"action=checkScore&username=%@",username];
        NSLog(@"PostData: %@",post);
        NSURL *url = [NSURL URLWithString:URLADDRESS];
        NSLog(@"PostURL: %@",url);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        
        if ([response statusCode] >= 200 && [response statusCode] < 300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            //NSDictionary *jsonData1;
            //NSMutableDictionary *jsonData;
            id jso = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
            
            if (jso == nil) {
                
            } else if ([jso isKindOfClass:[NSArray class]]) {
                NSLog(@"It is an array");
                NSArray *jsonArray = jso;
                NSUInteger numofentries = jsonArray.count;
                printf("%d",numofentries);
                for (int i = 0; i < jsonArray.count; i++)
                {
                    
                    jsonData = jsonArray[i];
                }
                
                // process array elements
            } else if ([jso isKindOfClass:[NSDictionary class]]) {
                NSLog(@"It is an dictionnary");
                jsonData = jso;
                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
            }
            
            //jsonData = [jsonData1 mutableCopy];
            
            if(![jsonData[@"score"] isEqualToString:@""]){
                score = jsonData[@"score"];
            }
            else if([jsonData[@"score"] isEqualToString:@"ERROR"]){
                score = @"ERROR";
            }
            else{
                score = @"0";
            }
            
        }
        else{
            score = @"ERROR";
            [self alertStatus:@"connection failed" :@"failed to check score" :0];
        }
    }
    
    @catch (NSException *exception) {
        score = @"exception";
        NSLog(@"Exception: %@", exception);
        [self alertStatus:@"connection failed" :@"Notice" :0];
        //sampleDetail.text = self.sampleDetailInit;
    }
    return score;
    
}





-(BOOL) textFieldShouldReturn:(UITextField *)textField{//click on return to remove the keyboard
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)informationHelper:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"single" forKey:@"infoFrom"];
    [self performSegueWithIdentifier:@"single_game_info" sender:self];//page nivagation
}
@end
