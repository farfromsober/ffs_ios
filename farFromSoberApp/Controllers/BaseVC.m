//
//  BaseViewController.m
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"
#import "AlertUtil.h"

@interface BaseVC ()

@end

@implementation BaseVC

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [APIManager sharedManager];
    [AppStyle styleNavBar:self.navigationController.navigationBar];
}

- (UIAlertController *)errorAlert:(NSString *)message {
    return [[AlertUtil alloc] alertwithTitle:@"Error"
                                  andMessage:message
                           andYesButtonTitle:@""
                            andNoButtonTitle:@"Cerrar"];
}

@end
