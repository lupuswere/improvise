//
//  ChannelViewController.h
//  Improvise
//
//  Created by Lifei Li on 15/4/21.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelViewController : UIViewController
- (IBAction)backToChannelsPage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) NSString *channelName;
@end
