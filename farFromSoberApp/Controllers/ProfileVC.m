//
//  ProfileVC.m
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProfileVC.h"

#import "UserManager.h"
#import "AppNavigation.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add logout button for TESTING
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    logoutButton.frame = CGRectMake(0, 0, 120, 40);
    logoutButton.center = self.view.center;
    
    [self.view addSubview:logoutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    UserManager *manager = [UserManager sharedInstance];
    if ([manager resetUser]) {
        [AppNavigation onLogoutFromViewController:self];
    }
}


@end
