//
//  ViewController.m
//  Improvise-Prototype
//
//  Created by Lifei Li on 15/4/7.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.webPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://improvise.jit.su"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
