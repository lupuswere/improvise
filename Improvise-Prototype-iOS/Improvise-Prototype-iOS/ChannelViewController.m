//
//  ChannelViewController.m
//  Improvise
//
//  Created by Lifei Li on 15/4/21.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "ChannelViewController.h"
#import <SIOSocket/SIOSocket.h>
@interface ChannelViewController ()
@property (strong, nonatomic) SIOSocket *socket;
@property BOOL socketIsConnected;
@end

@implementation ChannelViewController

- (void)viewDidLoad {
    self.messageTextField.text = self.channelName;
    [super viewDidLoad];
    //TODO Connect to WebSocket
    [SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
        self.socket = socket;
    }];
    __weak typeof(self) weakSelf = self;
    self.socket.onConnect = ^()
    {
        weakSelf.socketIsConnected = YES;
    };
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

- (IBAction)backToChannelsPage:(UIButton *)sender {
    [self performSegueWithIdentifier:@"backToChannelsSegue" sender:sender];
}
@end
