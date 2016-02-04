//
//  BaseViewController.h
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStyle.h"

#import "APIManager.h"
#import "MBProgressHUD.h"

@interface BaseVC : UIViewController

@property (nonatomic, strong) APIManager *api;

- (UIAlertController *)errorAlert:(NSString *)message;

@end
