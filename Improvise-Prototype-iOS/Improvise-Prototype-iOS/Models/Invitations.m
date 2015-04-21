//
//  Invitations.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/20.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "Invitations.h"

@implementation Invitations
- (id)init
{
    if (self = [super init]) {
        _acceptedInvitations = [NSMutableArray array];
        _invitedInvitations = [NSMutableArray array];
    }
    return self;
}

- (void) addAcceptedInvitations:(AcceptedInvitation *) acceptedInvitation
{
    [self.acceptedInvitations addObject:acceptedInvitation];
}

- (void) addInvitedInvitations:(InvitedInvitation *) invitedInvitation
{
    [self.invitedInvitations addObject:invitedInvitation];
}

@end
