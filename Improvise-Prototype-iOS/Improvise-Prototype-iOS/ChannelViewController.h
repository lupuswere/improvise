//
//  ChannelViewController.h
//  Improvise
//
//  Created by Lifei Li on 15/4/21.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIOSocket/SIOSocket.h>
@interface ChannelViewController : UIViewController
- (IBAction)backToChannelsPage:(UIButton *)sender;
- (IBAction)sendMessageButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButtonProperty;
- (IBAction)tapOnScreen:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) NSString *channelName;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) SIOSocket *socket;
@property (strong, nonatomic) NSMutableArray *messageList;
@property BOOL socketIsConnected;
@end
