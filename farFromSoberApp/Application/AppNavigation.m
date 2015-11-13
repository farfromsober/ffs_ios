//
//  AppNavigation.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "AppNavigation.h"
#import <UIKit/UIKit.h>

#import "ProductListVC.h"
#import "MapVC.h"
#import "NewItemVC.h"
#import "NotificationListVC.h"
#import "ProfileVC.h"

#import "UINavigationController+Initializer.h"

@interface AppNavigation ()

@end

@implementation AppNavigation

+ (UITabBarController *)tabBarController {
    
    // Create viewcontrollers for each tab EMBEDDED IN NAVIGATION CONTROLLERS!!
    // Why? Because we are going to use 'push' navigation inside each tab.
    UINavigationController *productsNVC = [UINavigationController navigationControllerWithRoot:[ProductListVC new]];
    UINavigationController *mapNVC = [UINavigationController navigationControllerWithRoot:[MapVC new]];
    UINavigationController *newNVC = [UINavigationController navigationControllerWithRoot:[NewItemVC new]];
    UINavigationController *nofiticationsNVC = [UINavigationController navigationControllerWithRoot:[NotificationListVC new]];
    UINavigationController *profileNVC = [UINavigationController navigationControllerWithRoot:[ProfileVC new]];
    
    // Create an ORDERED array of VCs.
    NSArray *vcs = @[productsNVC, mapNVC, newNVC, nofiticationsNVC, profileNVC];
    
    // Create tabBarController
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = vcs;
    
    // Configure tabBarItems
    #pragma mark - TODO: set normal and selected icons
    productsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Products" image:nil selectedImage:nil];
    mapNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:nil selectedImage:nil];
    newNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New" image:nil selectedImage:nil];
    nofiticationsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:nil selectedImage:nil];
    profileNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil selectedImage:nil];
    
    return tabController;
}


@end
