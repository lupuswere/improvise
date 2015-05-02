//
//  ProfileViewController.m
//  Improvise-Prototype-iOS
//
//  Created by Lifei Li on 15/4/19.
//  Copyright (c) 2015年 Lifei Li. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UserProfile.h"
@interface ProfileViewController ()
@property (strong, nonatomic) NSString *profileId;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.nameTag.text = appDelegate.curUsername;
    self.profileId = @"";
    [self loadUserProfileData];
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
- (NSArray *)userProfileExist
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError *error2;
    NSString *urlStrProfile = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/profile/", appDelegate.curUsername];
    NSURL *urlProfile = [NSURL URLWithString:urlStrProfile];
    NSMutableURLRequest *requestProfile = [NSMutableURLRequest requestWithURL:urlProfile];
    [requestProfile setHTTPMethod:@"GET"];
    [requestProfile setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *dataProfile = [NSURLConnection sendSynchronousRequest:requestProfile returningResponse: nil error:&error2];
    if(dataProfile) {
        NSArray *JSONProfile =
        [NSJSONSerialization JSONObjectWithData: dataProfile
                                        options: NSJSONReadingMutableContainers
                                          error: &error2];
        if(JSONProfile) {
            return JSONProfile;
        }
    }
    return nil;
}

- (void)loadUserProfileData
{
    NSDictionary *userProfileDict = [[self userProfileExist] firstObject];
    if(userProfileDict && [userProfileDict count] != 0) {
        self.profileId = [userProfileDict objectForKey:@"_id"];
        self.genderTextField.text = [userProfileDict objectForKey:@"gender"];
        self.addressTextField.text = [userProfileDict objectForKey:@"address"];
        self.cityTextField.text = [userProfileDict objectForKey:@"city"];
        self.provinceTextField.text = [userProfileDict objectForKey:@"province"];
        self.zipCodeTextField.text = [userProfileDict objectForKey:@"zipCode"];
        self.countryTextField.text = [userProfileDict objectForKey:@"country"];
        self.hobbyTextField.text = [userProfileDict objectForKey:@"hobby"];
    } else {
        self.genderTextField.text = @"";
        self.addressTextField.text = @"";
        self.cityTextField.text = @"";
        self.provinceTextField.text = @"";
        self.zipCodeTextField.text = @"";
        self.countryTextField.text = @"";
        self.hobbyTextField.text = @"";
    }
}

- (IBAction)logOutButton:(UIButton *)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.curUsername = @"";
    appDelegate.invitations = nil;
    [self performSegueWithIdentifier:@"logOutSegue" sender:sender];
}


- (IBAction)tapOnScreen:(UITapGestureRecognizer *)sender {
    [self.genderTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.provinceTextField resignFirstResponder];
    [self.countryTextField resignFirstResponder];
    [self.zipCodeTextField resignFirstResponder];
    [self.hobbyTextField resignFirstResponder];
}

- (IBAction)updateButton:(UIButton *)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *userProfileDict = [[self userProfileExist] firstObject];
    if(!self.genderTextField.text) {
        self.genderTextField.text = @"";
    }
    if(!self.addressTextField.text) {
        self.addressTextField.text = @"";
    }
    if(!self.cityTextField.text) {
        self.cityTextField.text = @"";
    }
    if(!self.provinceTextField.text) {
        self.provinceTextField.text = @"";
    }
    if(!self.zipCodeTextField.text) {
        self.zipCodeTextField.text = @"";
    }
    if(!self.countryTextField.text) {
        self.countryTextField.text = @"";
    }
    if(!self.hobbyTextField.text) {
        self.hobbyTextField.text = @"";
    }
    
    if(userProfileDict && [userProfileDict count] != 0) {
        //PUT
        NSError *putError;
        NSString *put = [NSString stringWithFormat:@"id=%@&gender=%@&address=%@&city=%@&province=%@&zipCode=%@&country=%@&hobby=%@", self.profileId, self.genderTextField.text, self.addressTextField.text, self.cityTextField.text, self.provinceTextField.text, self.zipCodeTextField.text, self.countryTextField.text, self.hobbyTextField.text];
        NSData *putData = [put dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *putLength = [NSString stringWithFormat:@"%lu", (unsigned long)[putData length]];
        NSString *urlStrPUT = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/profile/", appDelegate.curUsername];
        NSMutableURLRequest *putRequest = [[NSMutableURLRequest alloc] init];
        [putRequest setURL:[NSURL URLWithString:urlStrPUT]];
        [putRequest setHTTPMethod:@"PUT"];
        [putRequest setValue:putLength forHTTPHeaderField:@"Content-Length"];
        [putRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [putRequest setHTTPBody:putData];
        NSData *dataPUT = [NSURLConnection sendSynchronousRequest:putRequest returningResponse: nil error:&putError];
        if(dataPUT) {
            //TODO
        } else {
            NSLog(@"Unknown error.");
        }
    } else {
        //POST
        NSError *postError;
        NSString *post = [NSString stringWithFormat:@"username=%@&gender=%@&address=%@&city=%@&province=%@&zipCode=%@&country=%@&hobby=%@", appDelegate.curUsername, self.genderTextField.text, self.addressTextField.text, self.cityTextField.text, self.provinceTextField.text, self.zipCodeTextField.text, self.countryTextField.text, self.hobbyTextField.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSString *urlStrPOST = [NSString stringWithFormat:@"%@%@",@"http://improvise.jit.su/profile/", appDelegate.curUsername];
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:[NSURL URLWithString:urlStrPOST]];
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [postRequest setHTTPBody:postData];
        NSData *dataPOSTed = [NSURLConnection sendSynchronousRequest:postRequest returningResponse: nil error:&postError];
        if(dataPOSTed) {
            //TODO
        } else {
            NSLog(@"Unknown error.");
        }
    }
}
@end
