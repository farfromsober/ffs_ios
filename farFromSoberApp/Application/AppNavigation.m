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

#import "LoginViewController.h"

#import "UINavigationController+Initializer.h"

@interface AppNavigation ()

@end

@implementation AppNavigation

+ (UITabBarController *)tabBarController {
    
    // Create viewcontrollers for each tab EMBEDDED IN NAVIGATION CONTROLLERS!!
    // Why? Because we are going to use 'push' navigation inside each tab.
    UINavigationController *productsNVC = [UINavigationController withRoot:[ProductListVC new]];
    UINavigationController *mapNVC = [UINavigationController withRoot:[MapVC new]];
    //UINavigationController *newNVC = [UINavigationController withRoot:[NewItemVC new]];
    UINavigationController *nofiticationsNVC = [UINavigationController withRoot:[NotificationListVC new]];
    UINavigationController *profileNVC = [UINavigationController withRoot:[ProfileVC new]];
    
    // Create an ORDERED array of VCs.
    NSArray *vcs = @[productsNVC, mapNVC, nofiticationsNVC, profileNVC];
    
    // Create tabBarController
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = vcs;
    
    // Configure tabBarItems
    #pragma mark - TODO: set normal and selected icons
    productsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Products" image:[UIImage imageNamed:@"Products Inactive"] selectedImage:nil];
    mapNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"Map Inactive"] selectedImage:[UIImage imageNamed:@"Map Active"]];
    //newNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"Products Inactive"] selectedImage:nil];
    nofiticationsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[UIImage imageNamed:@"Notification Inactive"] selectedImage:[UIImage imageNamed:@"Notification Active"]];
    profileNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil selectedImage:[UIImage imageNamed:@"Profile Active"]];
    
    //Background image
    tabController.tabBar.backgroundImage = [UIImage imageNamed:@"Bar"];
    
    // Hide back button
    tabController.navigationItem.hidesBackButton = YES;
    
    return tabController;
}

+(UINavigationController *)loginController{
    LoginViewController *logVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [UINavigationController withRoot:logVC];
    
    return nav;
}

@end
