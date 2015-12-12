//
//  AppStyle.h
//  farFromSoberApp
//
//  Created by David Regatos on 06/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class ProductCollectionViewCell;

@interface AppStyle : NSObject

+ (UIColor *)mainColorLight;
+ (UIColor *)mainColorDark;

+ (void)applyGlobalStyles;
+ (void)styleNavBar:(UINavigationBar *)navBar;

+ (void)styleLoginViewController:(LoginViewController *)vc;

+ (void)styleProductCell:(ProductCollectionViewCell *)cell;

@end
