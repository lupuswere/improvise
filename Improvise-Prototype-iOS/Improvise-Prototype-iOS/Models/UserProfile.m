//
//  UserProfile.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
- (instancetype)init
{
    if (self = [super init]) {
        _username = @"";
        _gender = @"";
        _address = @"";
        _city = @"";
        _province = @"";
        _zipCode = @"";
        _hobby = @"";
    }
    return self;
}
@end
