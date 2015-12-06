//
//  AppStyle.m
//  farFromSoberApp
//
//  Created by David Regatos on 06/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "AppStyle.h"

#import "LoginViewController.h"

@implementation AppStyle

#pragma mark - Colors

+ (UIColor *)si_veryLightPinkColor {
    return [UIColor colorWithRed:252.0f / 255.0f
                           green:235.0f / 255.0f
                            blue:227.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_lightPeachColor {
    return [UIColor colorWithRed:252.0f / 255.0f
                           green:218.0f / 255.0f
                            blue:202.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_lightSalmonColor {
    return [UIColor colorWithRed:252.0f / 255.0f
                           green:183.0f / 255.0f
                            blue:151.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_paleOrangeColor {
    return [UIColor colorWithRed:252.0f / 255.0f
                           green:149.0f / 255.0f
                            blue:101.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_orangishColor {
    return [UIColor colorWithRed:252.0f / 255.0f
                           green:114.0f / 255.0f
                            blue:50.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_blackColor {
    return [UIColor colorWithRed:41.0f / 255.0f
                           green:37.0f / 255.0f
                            blue:37.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_whiteColor {
    return [UIColor colorWithRed:255.0f / 255.0f
                           green:255.0f / 255.0f
                            blue:255.0f / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)si_charcoalGreyColor {
    return [UIColor colorWithRed:41.0f / 255.0f
                           green:47.0f / 255.0f
                            blue:51.0f / 255.0f
                           alpha:1.0f];
}

#pragma mark - Global

+ (void)applyGlobalStyles {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - LoginViewController

+ (void)styleLoginViewController:(LoginViewController *)vc {
    
    vc.view.backgroundColor = [self si_lightPeachColor];
    
    vc.img4Sale.image = [UIImage imageNamed:@"4sale!"];
    
    vc.usernameLabel.textColor = [self si_orangishColor];
    vc.passwordLabel.textColor = [self si_orangishColor];
    
    [AppStyle styleTextField:vc.txtUser];
    [AppStyle styleTextField:vc.txtPass];
    
    [vc.btRememberPass setTitleColor:[self si_orangishColor] forState:UIControlStateNormal];
    [vc.btSignUp setTitleColor:[self si_orangishColor] forState:UIControlStateNormal];
    [AppStyle styleButton:vc.btLogin];
}

#pragma mark - Shared

+ (void)styleTextField:(UITextField *) txtField {
    txtField.clipsToBounds = YES;
    txtField.textColor = [self si_orangishColor];
    txtField.tintColor = [self si_orangishColor];
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.layer.borderColor = [self si_lightSalmonColor].CGColor;
    txtField.layer.borderWidth = 1.0;
    txtField.layer.cornerRadius = 5.0;
}

+ (void)styleButton:(UIButton *)btn {
    btn.backgroundColor = [self si_orangishColor];
    [btn setTitleColor:[self si_whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0;
}

@end
