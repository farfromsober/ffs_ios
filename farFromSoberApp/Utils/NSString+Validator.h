//
//  NSString+Additions.h
//  EdCoApp
//
//  Created by David Regatos on 31/03/14.
//  Copyright (c) 2014 edCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validator)

+ (BOOL)isEmpty:(NSString *)value;
+ (BOOL)isValidEmail:(NSString *)emailString;

@end
