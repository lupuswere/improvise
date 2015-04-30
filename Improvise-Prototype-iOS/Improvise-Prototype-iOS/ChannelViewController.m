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
@property (strong, nonatomic) NSMutableDictionary *acceptedRecords;
@end

@implementation ChannelViewController

- (void)viewDidLoad {
//    self.messageTextField.text = self.channelName;
    if ([self.channelName isEqualToString:@"sports"]) {
        self.actualChannel = @"message";
    }
    if (!self.acceptedRecords) {
        self.acceptedRecords = [[NSMutableDictionary alloc] init];
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
                 //TODO
             } else {
//                 [self.messageList addObject:message];
             }
             NSLog(@"!!!!!!!!!!!!!!!!!NOW THE COUNT IS!!!!!!!!!!! %lu", (unsigned long)[self.messageList count]);
             [self.messageTableView reloadData];
         }];
        [self establishConnection];
    }];
    [self.messageTableView reloadData];
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
//    NSString *indexPathStr = [NSString stringWithFormat:@"%@", indexPath];
//    if([self.acceptedRecords objectForKey:indexPathStr]) {
//        [cell setBackgroundColor:[UIColor colorWithRed:2 green:.8 blue:.2 alpha:1]];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    /* SubString */
    NSString *haystack = theCell.detailTextLabel.text;
    NSString *prefix = @"from:";
    NSString *suffix = @"";
    NSRange needleRange = NSMakeRange(prefix.length,
                                      haystack.length - prefix.length - suffix.length);
    NSString *author = [haystack substringWithRange:needleRange];
    /**/
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(![appDelegate.curUsername isEqualToString:author] && ![self.acceptedRecords objectForKey:[NSString stringWithFormat:@"%@ %@", theCell.textLabel.text, theCell.detailTextLabel.text]]) {
        NSString *msg = [NSString stringWithFormat: @"%@%@", @"ACCEPTED! ", author];
        NSError *postError;
        NSString *post = [NSString stringWithFormat:@"sender=%@&content=%@&receiver=%@", author, theCell.textLabel.text, appDelegate.curUsername];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSString *urlStrPOST = [NSString stringWithFormat:@"http://improvise.jit.su/invitations"];
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:[NSURL URLWithString:urlStrPOST]];
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [postRequest setHTTPBody:postData];
        NSData *dataPOSTed = [NSURLConnection sendSynchronousRequest:postRequest returningResponse: nil error:&postError];
        if(dataPOSTed) {
            [self.acceptedRecords setObject:@"YES" forKey:[NSString stringWithFormat:@"%@ %@", theCell.textLabel.text, theCell.detailTextLabel.text]];
            [theCell setBackgroundColor:[UIColor colorWithRed:.2 green:.0 blue:.2 alpha:0.4]];
        } else {
            NSLog(@"Unknown Error: %@", postError);
        }
        [self establishConnection];
        [self.socket emit: self.actualChannel args: @[
                                                      msg
                                                      ]];
    }
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
- (IBAction)tapOnScreen:(UITapGestureRecognizer *)sender {
    [self.messageTextField resignFirstResponder];
}
@end
