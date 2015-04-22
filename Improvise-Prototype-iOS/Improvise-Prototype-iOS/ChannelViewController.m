//
//  ChannelViewController.m
//  Improvise
//
//  Created by Lifei Li on 15/4/21.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "ChannelViewController.h"
#import <SIOSocket/SIOSocket.h>
#import "AppDelegate.h"
#import "Message.h"
@interface ChannelViewController ()
@property BOOL established;
@property (strong, nonatomic) NSString *actualChannel;
@end

@implementation ChannelViewController

- (void)viewDidLoad {
//    self.messageTextField.text = self.channelName;
    if ([self.channelName isEqualToString:@"sports"]) {
        self.actualChannel = @"message";
    }
    [super viewDidLoad];
    if(!self.messageList) {
        self.messageList = [[NSMutableArray alloc] init];
    }
    //TODO Connect to WebSocket
    [SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
        self.socket = socket;
        __weak typeof(self) weakSelf = self;
        self.socket.onConnect = ^()
        {
            weakSelf.socketIsConnected = YES;
        };
        [self.socket on: self.actualChannel callback: ^(SIOParameterArray *args)
         {
//             NSString *messageStr = [args firstObject];
             NSDictionary *messageDict = [args firstObject];
             Message *message = [[Message alloc] init];
             message.author = [messageDict objectForKey:@"author"];
             message.msgType = [messageDict objectForKey:@"msgType"];
             message.text = [messageDict objectForKey:@"text"];
             if(message.msgType && [message.msgType isEqualToString:@"acceptance"]) {
                 
             } else {
                 [self.messageList addObject:message];
             }
             [self.messageTableView reloadData];
         }];
        [self establishConnection];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    Message *newMessage = [self.messageList objectAtIndex:row];
    cell.textLabel.text = newMessage.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", @"from:", newMessage.author];
    return cell;
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

- (IBAction)sendMessageButton:(UIButton *)sender {
    if (self.messageTextField.text && ![self.messageTextField.text isEqualToString:@""]) {
        [self.sendMessageButtonProperty setEnabled:NO];
        [self establishConnection];
        if(self.socketIsConnected) {
            [self.socket emit: self.actualChannel args: @[
                                                  [NSString stringWithFormat: @"%@", self.messageTextField.text]
                                                  ]];
        } else {
            [SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
                self.socket = socket;
                __weak typeof(self) weakSelf = self;
                self.socket.onConnect = ^()
                {
                    weakSelf.socketIsConnected = YES;
                };
            }];
        }
        self.messageTextField.text = @"";
        [self.sendMessageButtonProperty setEnabled:YES];
    }
}

- (void)establishConnection
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(!self.established) {
        if(self.socketIsConnected) {
            [self.socket emit: self.actualChannel args: @[
                                                  [NSString stringWithFormat: @"%@", appDelegate.curUsername]
                                                  ]];
            self.established = YES;
        } else {
            [SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
                self.socket = socket;
                __weak typeof(self) weakSelf = self;
                self.socket.onConnect = ^()
                {
                    weakSelf.socketIsConnected = YES;
                };
                [self.socket emit: self.actualChannel args: @[
                                                      [NSString stringWithFormat: @"%@", appDelegate.curUsername]
                                                      ]];
            }];
            self.established = YES;
        }
    }
}
@end
