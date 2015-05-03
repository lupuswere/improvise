//
//  FirstViewController.h
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIOSocket/SIOSocket.h>
@interface HomeViewController : UIViewController
- (IBAction)toSportsChannel:(UIButton *)sender;
- (IBAction)toDinnerChannel:(UIButton *)sender;
- (IBAction)toMovieChannel:(UIButton *)sender;
- (IBAction)clearAllInvitations:(UIButton *)sender;
- (IBAction)sportsChannelOpen:(UISwitch *)sender;
- (IBAction)dinnerChannelOpen:(UISwitch *)sender;
- (IBAction)movieChannelOpen:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *sportsMessageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dinnerMessageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieMessageCountLabel;
@property (strong, nonatomic) SIOSocket *socket;
@property BOOL socketIsConnected;
@end

