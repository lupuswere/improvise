//
//  FirstViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "HomeViewController.h"
#import <SIOSocket/SIOSocket.h>
#import "AppDelegate.h"
#import "ChannelViewController.h"
#import "Message.h"
@interface HomeViewController ()
@property BOOL established;
@property BOOL *sportsChannelOpen; //Just For Prototyping
@property (strong, nonatomic) NSMutableArray *sportsMessages;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [self setNavBarNames];
    if(!self.sportsMessages) {
        self.sportsMessages = [[NSMutableArray alloc] init];
    }
    self.sportsMessageCountLabel.text = @"0";
    self.dinnerMessageCountLabel.text = @"0";
    self.movieMessageCountLabel.text = @"0";
    [SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
        self.socket = socket;
        __weak typeof(self) weakSelf = self;
        self.socket.onConnect = ^()
        {
            weakSelf.socketIsConnected = YES;
        };
        [self.socket on: @"message" callback: ^(SIOParameterArray *args)
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
                 [self.sportsMessages addObject:message];
             }
             [self updateSportsChannelCount];
         }];
        [self establishConnection];
    }];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSportsChannelCount {
    self.sportsMessageCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.sportsMessages count]];
}

- (void)setNavBarNames {
    [[self.tabBarController.viewControllers objectAtIndex:0] setTitle:@"Home"];
    [[self.tabBarController.viewControllers objectAtIndex:1] setTitle:@"Invited"];
    [[self.tabBarController.viewControllers objectAtIndex:2] setTitle:@"Accepted"];
    [[self.tabBarController.viewControllers objectAtIndex:3] setTitle:@"Profile"];
}

- (IBAction)toSportsChannel:(UIButton *)sender {
    [self performSegueWithIdentifier:@"sportsChannelSegue" sender:sender];
}

- (IBAction)toDinnerChannel:(UIButton *)sender {
    [self performSegueWithIdentifier:@"dinnerChannelSegue" sender:sender];
}

- (IBAction)toMovieChannel:(UIButton *)sender {
    [self performSegueWithIdentifier:@"movieChannelSegue" sender:sender];
}

- (IBAction)clearAllInvitations:(UIButton *)sender {
    [self clearAcceptedInvitations];
    [self clearInvitedInvitations];
}

- (void)clearAcceptedInvitations
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError *deleteError;
    NSString *urlStrDELETE = [NSString stringWithFormat:@"%@%@",@"http://improvise.jit.su/acceptedInvitations/", appDelegate.curUsername];
    NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
    [deleteRequest setURL:[NSURL URLWithString:urlStrDELETE]];
    [deleteRequest setHTTPMethod:@"DELETE"];
    [deleteRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSData *dataDELETEd = [NSURLConnection sendSynchronousRequest:deleteRequest returningResponse: nil error:&deleteError];
    if(dataDELETEd) {
        //TODO
    } else {
        NSLog(@"Unknown error.");
    }
}

- (void)clearInvitedInvitations
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError *deleteError;
    NSString *urlStrDELETE = [NSString stringWithFormat:@"%@%@",@"http://improvise.jit.su/invitedInvitations/", appDelegate.curUsername];
    NSMutableURLRequest *deleteRequest = [[NSMutableURLRequest alloc] init];
    [deleteRequest setURL:[NSURL URLWithString:urlStrDELETE]];
    [deleteRequest setHTTPMethod:@"DELETE"];
    [deleteRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSData *dataDELETEd = [NSURLConnection sendSynchronousRequest:deleteRequest returningResponse: nil error:&deleteError];
    if(dataDELETEd) {
        //TODO
    } else {
        NSLog(@"Unknown error.");
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChannelViewController *destination = segue.destinationViewController;
    destination.channelName = @"";
    if([segue.identifier isEqualToString:@"sportsChannelSegue"]) {
        destination.channelName = @"sports";
    } else if([segue.identifier isEqualToString:@"dinnerChannelSegue"]) {
        destination.channelName = @"dinner";
    } else if([segue.identifier isEqualToString:@"movieChannelSegue"]) {
        destination.channelName = @"movie";
    }
    destination.messageList = self.sportsMessages;
}

- (void)establishConnection
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(!self.established) {
        if(self.socketIsConnected && self.sportsChannelOpen) {
            [self.socket emit: @"message" args: @[
                                                          [NSString stringWithFormat: @"%@", appDelegate.curUsername]
                                                          ]];
            self.established = YES;
        } else {
            if(self.sportsChannelOpen) {
                [SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
                    self.socket = socket;
                    __weak typeof(self) weakSelf = self;
                    self.socket.onConnect = ^()
                    {
                        weakSelf.socketIsConnected = YES;
                    };
                    [self.socket emit: @"message" args: @[
                                                                  [NSString stringWithFormat: @"%@", appDelegate.curUsername]
                                                                  ]];
                }];
                self.established = YES;
            }
        }
    }
}
@end
