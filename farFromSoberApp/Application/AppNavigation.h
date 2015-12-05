//
//  AppNavigation.h
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITabBarController;
@class UINavigationController;

@interface AppNavigation : NSObject

+ (UITabBarController *)tabBarController;
+ (UINavigationController *)loginController;

@end
