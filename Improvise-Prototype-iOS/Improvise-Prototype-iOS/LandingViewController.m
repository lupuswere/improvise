//
//  LandingViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "LandingViewController.h"
#import "AppDelegate.h"
//#import "UserProfile.h"
@interface LandingViewController ()

@end

@implementation LandingViewController
- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.curUsername && ![appDelegate.curUsername isEqualToString:@""]) {
        [self performSegueWithIdentifier: @"automaticLogInSegue" sender: self];
    }
}
- (void)viewDidLoad {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(!appDelegate.curUsername || [appDelegate.curUsername isEqualToString:@""]) {
        self.errorMessageText.text = @"";
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(UIButton *)sender {
    self.errorMessageText.text = @"";
    NSError *error;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/login/", self.usernameText.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error];
    if(data) {
//        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]); //Important test code
        NSDictionary *JSON =
        [NSJSONSerialization JSONObjectWithData: data
                                        options: NSJSONReadingMutableContainers
                                          error: &error];
//        NSLog(@"%@", JSON);
        if([[JSON objectForKey:@"username"] isEqualToString:self.usernameText.text] && [[JSON objectForKey:@"password"] isEqualToString:self.passwordText.text]) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.curUsername = [JSON objectForKey:@"username"];
            [self performSegueWithIdentifier:@"logInSegue" sender:sender];
        } else {
            self.errorMessageText.text = @"Wrong username or password.";
        }
    }
}

- (IBAction)signupButton:(UIButton *)sender {
    self.errorMessageText.text = @"";
    NSString *usernameText = self.usernameText.text;
    NSString *passwordText = self.passwordText.text;
    if (usernameText && ![usernameText isEqualToString:@""] && passwordText && ![passwordText isEqualToString:@""]) {
        NSError *error;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/checkuser/", usernameText];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error];
        if(data) {
            NSDictionary *JSON =
            [NSJSONSerialization JSONObjectWithData: data
                                            options: NSJSONReadingMutableContainers
                                              error: &error];
            if([JSON objectForKey:@"username"]) {
                self.errorMessageText.text = @"Username already exists!";
            } else {
                //post
                NSError *postError;
                NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", usernameText, passwordText];
                NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                
                NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
                NSString *urlStrPOST = [NSString stringWithFormat:@"http://improvise.jit.su/signup"];
                NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
                [postRequest setURL:[NSURL URLWithString:urlStrPOST]];
                [postRequest setHTTPMethod:@"POST"];
                [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [postRequest setHTTPBody:postData];
                NSData *dataPOSTed = [NSURLConnection sendSynchronousRequest:postRequest returningResponse: nil error:&postError];
                if(dataPOSTed) {
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    appDelegate.curUsername = usernameText;
                    [self performSegueWithIdentifier:@"logInSegue" sender:sender];
                } else {
                    self.errorMessageText.text = @"Unknown error. Please try again later.";
                }
            }
        } else {
            self.errorMessageText.text = @"Unknown error. Please try again later.";
        }
    } else {
        self.errorMessageText.text = @"Username or password is empty!";
    }
}

- (IBAction)tapOnScreen:(UITapGestureRecognizer *)sender {
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}
@end
