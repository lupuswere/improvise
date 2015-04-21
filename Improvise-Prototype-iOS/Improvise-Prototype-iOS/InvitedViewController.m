//
//  SecondViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "InvitedViewController.h"
#import "AppDelegate.h"
@interface InvitedViewController ()
@property (strong, nonatomic) Invitations *invitations;
@property (strong, nonatomic) NSDictionary *groupedInvitedInvitations;
@end

@implementation InvitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshAcceptedInvitationsList
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.invitations = [[Invitations alloc] init];
    /* Load Invited Invitations */
    NSError *error2;
    NSString *urlStrInvitedInvitations = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/invitedInvitations/", appDelegate.curUsername];
    NSURL *urlInvitedInvitations = [NSURL URLWithString:urlStrInvitedInvitations];
    NSMutableURLRequest *requestInvitedInvitations = [NSMutableURLRequest requestWithURL:urlInvitedInvitations];
    [requestInvitedInvitations setHTTPMethod:@"GET"];
    [requestInvitedInvitations setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *dataInvitedInvitations = [NSURLConnection sendSynchronousRequest:requestInvitedInvitations returningResponse: nil error:&error2];
    if(dataInvitedInvitations) {
        NSMutableArray *JSONInvitedInvitations =
        [NSJSONSerialization JSONObjectWithData: dataInvitedInvitations
                                        options: NSJSONReadingMutableContainers
                                          error: &error2];
        //        NSLog(@"%@", JSONInvitedInvitations);
        for(id element in JSONInvitedInvitations) {
            InvitedInvitation *invitedInvitation = [[InvitedInvitation alloc] init];
            invitedInvitation.sender = [element objectForKey:@"sender"];
            invitedInvitation.content = [element objectForKey:@"content"];
            invitedInvitation.receiver = [element objectForKey:@"receiver"];
            //TODO: group invited invitations
            
            [appDelegate.invitations.invitedInvitations addObject:invitedInvitation];
        }
    }
    /* Load Accepted Invitations */
    /*NSError *error3;
    NSString *urlStrAcceptedInvitations = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/acceptedInvitations/", appDelegate.curUsername];
    NSURL *urlAcceptedInvitations = [NSURL URLWithString:urlStrAcceptedInvitations];
    NSMutableURLRequest *requestAcceptedInvitations = [NSMutableURLRequest requestWithURL:urlAcceptedInvitations];
    [requestAcceptedInvitations setHTTPMethod:@"GET"];
    [requestAcceptedInvitations setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *dataAcceptedInvitations = [NSURLConnection sendSynchronousRequest:requestAcceptedInvitations returningResponse: nil error:&error3];
    if(dataAcceptedInvitations) {
        NSMutableArray *JSONAcceptedInvitations =
        [NSJSONSerialization JSONObjectWithData: dataAcceptedInvitations
                                        options: NSJSONReadingMutableContainers
                                          error: &error3];
        //        NSLog(@"%@", JSONAcceptedInvitations);
        for(id element in JSONAcceptedInvitations) {
            AcceptedInvitation *acceptedInvitation = [[AcceptedInvitation alloc] init];
            acceptedInvitation.sender = [element objectForKey:@"sender"];
            acceptedInvitation.content = [element objectForKey:@"content"];
            acceptedInvitation.receiver = [element objectForKey:@"receiver"];
            [appDelegate.invitations.acceptedInvitations addObject:acceptedInvitation];
        }
    }*/
    _invitations = appDelegate.invitations;
}
@end
