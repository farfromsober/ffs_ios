//
//  BaseViewController.m
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"
#import "AppStyle.h"

@interface BaseVC ()

@end

@implementation BaseVC

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [APIManager sharedManager];
    [AppStyle styleNavBar:self.navigationController.navigationBar];
}

@end
