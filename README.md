# Improvise

_The repository for the client side (mobile) for improvise_

* Author: Lifei Li, Menglin He, Haoyu Liu, Weining Gu
* The server side code is [here](https://github.com/lupuswere/improvise-prototype).
## Repository structure
* Improvise-Prototype

This is the folder for a HTML wrapped mobile app. There is only one UIWebView in the app, showing the web app.

* Improvise-Prototype-iOS

This is the folder for the native iOS app.

## Functionalities
### Sending and Receiving Invitations

* This functionality is implemented via socket connection package SIOSocket.
* Relevant classes: HomeViewController, ChannelViewController
* A typical socket connection from SIOSocket to socket.io on a node.js server is like this:

```objective-c
[SIOSocket socketWithHost: @"http://improvise.jit.su" response: ^(SIOSocket *socket) {
        self.socket = socket;
        __weak typeof(self) weakSelf = self;
        self.socket.onConnect = ^()
        {
            weakSelf.socketIsConnected = YES;
        };
        [self.socket on: self.actualChannel callback: ^(SIOParameterArray *args)
         {
             NSDictionary *messageDict = [args firstObject];
             Message *message = [[Message alloc] init];
             message.author = [messageDict objectForKey:@"author"];
             message.msgType = [messageDict objectForKey:@"msgType"];
             message.text = [messageDict objectForKey:@"text"];
             if(message.msgType && [message.msgType isEqualToString:@"acceptance"]) {
                 //TODO
             } else {
                 [self.messageList addObject:message];
             }
         }];
        [self establishConnection];
    }];
```

### Checking received and sent invitations

* This functionality is implemented via built-in classes to send calls to REST APIs on our server.
* Relevant classes: AcceptedViewController, InvitedViewController
* A typical REST API call is like this:

```objective-c
NSError *error3;
NSString *urlStrAcceptedInvitations = [NSString stringWithFormat:@"%@%@", @"http://improvise.jit.su/acceptedInvitations/", appDelegate.curUsername];
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
    for(id element in JSONAcceptedInvitations) {
        AcceptedInvitation *acceptedInvitation = [[AcceptedInvitation alloc] init];
        acceptedInvitation.sender = [element objectForKey:@"sender"];
        acceptedInvitation.content = [element objectForKey:@"content"];
        acceptedInvitation.receiver = [element objectForKey:@"receiver"];
        [appDelegate.invitations.acceptedInvitations addObject:acceptedInvitation];
    }
}
```

### Getting and updating user profile.

* The same as above.
* Relevant class: ProfileViewController

### Log in and Sign up

* The same as above.
* Relevant class: LandingViewController

### Push notifications
* This is the [tutorial](http://www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1) for the mobile side.
* Relevant class: AppDelegate
* Notice: the code for AppDelegate may expire as the iOS version upgrades. If come across problems, please check out latest code for this online.

## Current Issue
* When in HomeViewController and receives new messages then goes into ChannelViewController, the presentation of messages produces duplicates.