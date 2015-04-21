//
//  AppDelegate.h
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invitations.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *curUsername;
@property (strong, nonatomic) Invitations *invitations;

@end

