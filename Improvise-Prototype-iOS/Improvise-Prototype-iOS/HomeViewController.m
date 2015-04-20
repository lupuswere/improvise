//
//  FirstViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    //Test Code
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.curUsername) {
        self.testLabel.text = appDelegate.curUsername;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
