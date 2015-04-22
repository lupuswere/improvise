//
//  Message.h
//  Improvise
//
//  Created by Lifei Li on 15/4/21.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *msgType;
@property (strong, nonatomic) NSString *text;
@end
