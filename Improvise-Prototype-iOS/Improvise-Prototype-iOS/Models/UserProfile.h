//
//  UserProfile.h
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *hobby;
@end
