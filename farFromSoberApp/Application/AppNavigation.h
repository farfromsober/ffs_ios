//
//  AppNavigation.h
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppNavigation : NSObject

+ (UITabBarController *)tabBarController;
+ (UINavigationController *)loginController;

+ (void)onLoginFromViewController:(UIViewController *)vc;
+ (void)onLogoutFromViewController:(UIViewController *)vc;

@end
