//
//  NSString+Additions.m
//  EdCoApp
//
//  Created by David Regatos on 31/03/14.
//  Copyright (c) 2014 edCo. All rights reserved.
//

#import "NSString+Validator.h"

@implementation NSString (Validator)

+ (BOOL)isEmpty:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return value == nil ||
           value == (id)[NSNull null] ||
          [value isEqualToString:@""] ||
         ([value respondsToSelector:@selector(length)] && [value length] == 0);
}

+ (BOOL)isValidEmail:(NSString *)emailString {
    // Source: http://www.iossnippet.com/snippets/mail/how-to-validate-an-e-mail-address-in-objective-c-ios/
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
//    DMLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
