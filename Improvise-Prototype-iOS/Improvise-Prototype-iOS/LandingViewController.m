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
#import "AcceptedInvitation.h"
#import "InvitedInvitation.h"
#import "Invitations.h"
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
    NSString *usernameText = self.usernameText.text;
    NSString *passwordText = self.passwordText.text;
    NSError *error;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/login/", usernameText];
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
        if([[JSON objectForKey:@"username"] isEqualToString:usernameText] && [[JSON objectForKey:@"password"] isEqualToString:passwordText]) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.curUsername = [JSON objectForKey:@"username"];
            /* Load Invited Invitations */
            NSError *error2;
            NSString *urlStrInvitedInvitations = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/invitedInvitations/", usernameText];
            NSURL *urlInvitedInvitations = [NSURL URLWithString:urlStrInvitedInvitations];
            NSMutableURLRequest *requestInvitedInvitations = [NSMutableURLRequest requestWithURL:urlInvitedInvitations];
            [requestInvitedInvitations setHTTPMethod:@"GET"];
            [requestInvitedInvitations setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSData *dataInvitedInvitations = [NSURLConnection sendSynchronousRequest:requestInvitedInvitations returningResponse: nil error:&error2];
            if(dataInvitedInvitations) {
                NSMutableArray *JSONInvitedInvitations =
                [NSJSONSerialization JSONObjectWithData: dataInvitedInvitations
                                                options: NSJSONReadingMutableContainers
                                                  error: &error2];
//                NSLog(@"%@", JSONInvitedInvitations);
                for(id element in JSONInvitedInvitations) {
                    InvitedInvitation *invitedInvitation = [[InvitedInvitation alloc] init];
                    invitedInvitation.sender = [element objectForKey:@"sender"];
                    invitedInvitation.content = [element objectForKey:@"content"];
                    invitedInvitation.receiver = [element objectForKey:@"receiver"];
                    [appDelegate.invitations.invitedInvitations addObject:invitedInvitation];
                }
            }
            /* Load Accepted Invitations */
            NSError *error3;
            NSString *urlStrAcceptedInvitations = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/acceptedInvitations/", usernameText];
            NSURL *urlAcceptedInvitations = [NSURL URLWithString:urlStrAcceptedInvitations];
            NSMutableURLRequest *requestAcceptedInvitations = [NSMutableURLRequest requestWithURL:urlAcceptedInvitations];
            [requestAcceptedInvitations setHTTPMethod:@"GET"];
            [requestAcceptedInvitations setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSData *dataAcceptedInvitations = [NSURLConnection sendSynchronousRequest:requestAcceptedInvitations returningResponse: nil error:&error3];
            if(dataAcceptedInvitations) {
                NSMutableArray *JSONAcceptedInvitations =
                [NSJSONSerialization JSONObjectWithData: dataAcceptedInvitations
                                                options: NSJSONReadingMutableContainers
                                                  error: &error3];
//                NSLog(@"%@", JSONAcceptedInvitations);
                for(id element in JSONAcceptedInvitations) {
                    AcceptedInvitation *acceptedInvitation = [[AcceptedInvitation alloc] init];
                    acceptedInvitation.sender = [element objectForKey:@"sender"];
                    acceptedInvitation.content = [element objectForKey:@"content"];
                    acceptedInvitation.receiver = [element objectForKey:@"receiver"];
                    [appDelegate.invitations.acceptedInvitations addObject:acceptedInvitation];
                }
            }
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
                
                NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
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

- (IBAction)passwordGo:(UITextField *)sender {
    [self loginButton:sender];
}


@end
