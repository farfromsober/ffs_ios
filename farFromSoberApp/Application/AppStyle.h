//
//  AppStyle.h
//  farFromSoberApp
//
//  Created by David Regatos on 06/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginViewController;

@interface AppStyle : NSObject

+ (void)applyGlobalStyle;

+ (void)styleLoginViewController:(LoginViewController *)vc;

@end
