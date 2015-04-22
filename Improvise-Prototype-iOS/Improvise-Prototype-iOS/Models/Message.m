//
//  Message.m
//  Improvise
//
//  Created by Lifei Li on 15/4/21.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "Message.h"

@implementation Message
- (id)init
{
    if (self = [super init]) {
        _author = @"";
        _msgType = @"";
        _text = @"";
    }
    return self;
}
@end
