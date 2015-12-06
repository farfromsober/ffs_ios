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

#import "UIImage+ImageWithColor.h"

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
    productsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Products" image:[[UIImage imageNamed:@"Products Inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"Products Active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    mapNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[[UIImage imageNamed:@"Map Inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"Map Active"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    //newNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"Products Inactive"] selectedImage:nil];
    nofiticationsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[[UIImage imageNamed:@"Notification Inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"Notification Active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    profileNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[[UIImage imageNamed:@"Profile inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"Profile Active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //Background image
    tabController.tabBar.backgroundImage = [UIImage imageNamed:@"Bar"];
    tabController.tabBar.shadowImage = [[UIImage alloc] init];
    
    //Tabbar text color
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:252/255.0f green:114/255.0f blue:50/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    
    // Hide back button
    tabController.navigationItem.hidesBackButton = YES;
    
    return tabController;
}

+ (UINavigationController *)loginController {
    LoginViewController *logVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [UINavigationController withRoot:logVC];
    
    return nav;
}

+ (void)onLoginFromViewController:(UIViewController *)vc {
    // Create next VC
    UITabBarController *tabController = [self tabBarController];
    tabController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // Present next VC from current VC
    [vc presentViewController:tabController animated:YES completion:nil];
}

+ (void)onLogoutFromViewController:(UIViewController *)vc {
    // Create next VC
    LoginViewController *logVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [UINavigationController withRoot:logVC];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // Present next VC from current VC
    [vc presentViewController:nav animated:YES completion:nil];
}


@end
