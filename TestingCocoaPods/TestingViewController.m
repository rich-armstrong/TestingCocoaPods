//
//  TestingViewController.m
//  TestingCocoaPods
//
//  Created by Raichu on 5/20/14.
//  Copyright (c) 2014 RealMassive. All rights reserved.
//

#import "TestingViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
//#import "LIALinkedInClientExampleCredentials.h"
#import "LIALinkedInApplication.h"
@interface TestingViewController ()

@property (strong, nonatomic) NSString * kClientID;
@property (strong, nonatomic) NSString * kClientSecret;
@property (strong, nonatomic) NSString * kState;
@property (strong, nonatomic) NSString * kRedirectURL;
@property (strong, nonatomic) NSString * kGrantedAccess;

@end

@implementation TestingViewController{
    LIALinkedInHttpClient *_client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _client = [self client];
}

- (IBAction)didTapConnectWithLinkedIn:(id)sender {
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}

- (void)requestMeWithToken:(NSString *)accessToken {
    NSLog(@"requestMeWithToken called: WithToken %@", accessToken);
////    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
//    
//        NSLog(@"current user %@", result);
//    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failed to fetch current user %@", error);
//    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://realmassive-staging.appspot.com/auth/linkedin2/callback"
                                                                                    clientId:@"bteml16sb4lb"
                                                                                clientSecret:@"vI3TW6zB91ZMgZC0" // Why didn't it like the "not so secret" secret of "XYZ123"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_fullprofile", @"r_network"]]; // r_fullprofile%20r_network
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

@end




















