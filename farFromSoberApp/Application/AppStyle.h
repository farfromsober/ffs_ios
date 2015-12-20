//
//  AppStyle.h
//  farFromSoberApp
//
//  Created by David Regatos on 06/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class LoginViewController;
@class ProductCollectionViewCell;
@class ProductDetailViewController;
@class FilterProductsViewController;

@interface AppStyle : NSObject

+ (UIColor *)mainColorLight;
+ (UIColor *)mainColorDark;

+ (void)applyGlobalStyles;
+ (void)styleNavBar:(UINavigationBar *)navBar;
+ (void)hideLogo:(BOOL)hide ToNavBar:(UINavigationBar *) navBar;
+ (void)addSearchBarToNavBar:(UINavigationBar *) navBar;
+ (void)removeSearchBarFromNavBar:(UINavigationBar *) navBar;


+ (void)styleLoginViewController:(LoginViewController *)vc;
+ (void)styleProductDetailViewController:(ProductDetailViewController *)vc;
+ (void)styleFilterProductsViewController:(FilterProductsViewController *)vc;

+ (void)styleProductCell:(ProductCollectionViewCell *)cell;

+(MBProgressHUD *) getLoadingHUDWithView:(UIView *) view
                                 message:(NSString *) message;

@end
