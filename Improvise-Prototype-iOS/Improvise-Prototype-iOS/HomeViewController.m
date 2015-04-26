//
//  FirstViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ChannelViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [self setNavBarNames];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
@end
