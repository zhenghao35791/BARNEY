//
//  WelcomeViewController.h
//  BreakoutSpriteKitTutorial
//
//  Created by Hongnan Yang on 2014-10-13.
//  Copyright (c) 2014年 Barbara Köhler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
- (IBAction)leve1Game:(id)sender;
- (IBAction)level2Game:(id)sender;
- (IBAction)level3Game:(id)sender;
- (IBAction)Quit:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
