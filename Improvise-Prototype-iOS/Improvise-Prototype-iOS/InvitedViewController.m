//
//  SecondViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "InvitedViewController.h"
#import "AppDelegate.h"
#import "NewAcceptedInvitation.h"
@interface InvitedViewController ()
@property (strong, nonatomic) Invitations *invitations;
@property (strong, nonatomic) NSMutableArray *contentReceivers;
@end

@implementation InvitedViewController

- (void)viewDidLoad {
    [self refreshInvitedInvitationsList];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshInvitedInvitationsList];
    [self.invitedInvitationsTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentReceivers count];
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
    NewAcceptedInvitation *newAcceptedInvitation = [self.contentReceivers objectAtIndex:row];
    cell.textLabel.text = newAcceptedInvitation.content;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", @"Participants: ", newAcceptedInvitation.receivers];
    return cell;
}

- (void)refreshInvitedInvitationsList
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.invitations = [[Invitations alloc] init];
    NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
    self.contentReceivers = [[NSMutableArray alloc] init];
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
            if([tmpDictionary objectForKey:invitedInvitation.content]) {
                NSString *receivers = [tmpDictionary objectForKey:invitedInvitation.content];
                NSString *newReceivers = [NSString stringWithFormat:@"%@, %@", receivers, invitedInvitation.receiver];
                [tmpDictionary setObject:newReceivers forKey:invitedInvitation.content];
            } else {
                [tmpDictionary setObject:invitedInvitation.receiver forKey:invitedInvitation.content];
            }
            [appDelegate.invitations.invitedInvitations addObject:invitedInvitation];
        }
        for(id key in tmpDictionary) {
            NewAcceptedInvitation *newAcceptedInvitation = [[NewAcceptedInvitation alloc] init];
            newAcceptedInvitation.content = key;
            newAcceptedInvitation.receivers = [tmpDictionary objectForKey:key];
            [self.contentReceivers addObject:newAcceptedInvitation];
        }
    }
    _invitations = appDelegate.invitations;
}
@end
