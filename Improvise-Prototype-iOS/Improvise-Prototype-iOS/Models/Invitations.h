//
//  Invitations.h
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/20.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcceptedInvitation.h"
#import "InvitedInvitation.h"
@interface Invitations : NSObject
@property (strong, nonatomic) NSMutableArray *acceptedInvitations;
@property (strong, nonatomic) NSMutableArray *invitedInvitations;
- (void) addAcceptedInvitations:(AcceptedInvitation *) acceptedInvitation;
- (void) addInvitedInvitations:(InvitedInvitation *) invitedInvitation;
@end
