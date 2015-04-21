//
//  AcceptedViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "AcceptedViewController.h"
#import "AppDelegate.h"
@interface AcceptedViewController ()
@property (strong, nonatomic) Invitations *invitations;
@end

@implementation AcceptedViewController

- (void)viewDidLoad {
    [self refreshAcceptedInvitationsList];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshAcceptedInvitationsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.invitations.acceptedInvitations count];
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
    AcceptedInvitation *curAcceptedInvitation = [self.invitations.acceptedInvitations objectAtIndex:row];
    cell.textLabel.text = curAcceptedInvitation.content;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", @"from ", curAcceptedInvitation.sender];
    return cell;
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
            [appDelegate.invitations.invitedInvitations addObject:invitedInvitation];
        }
    }
    /* Load Accepted Invitations */
    NSError *error3;
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
    }
    _invitations = appDelegate.invitations;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
