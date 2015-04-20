//
//  LandingViewController.h
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingViewController : UIViewController
- (IBAction)loginButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageText;
- (IBAction)tapOnScreen:(UITapGestureRecognizer *)sender;

@end
