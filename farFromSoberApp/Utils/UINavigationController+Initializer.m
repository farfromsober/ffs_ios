//
//  UINavigationController+Initializer.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "UINavigationController+Initializer.h"

@implementation UINavigationController (Initializer)

+ (UINavigationController *)withRoot:(UIViewController *)vc {
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

@end
