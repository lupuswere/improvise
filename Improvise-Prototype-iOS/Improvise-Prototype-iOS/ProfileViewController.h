//
//  ProfileViewController.h
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
- (IBAction)logOutButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameTag;
- (IBAction)tapOnScreen:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *hobbyTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

- (IBAction)updateButton:(UIButton *)sender;


@end
