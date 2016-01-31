//
//  NSDictionary+Secure.m
//  farFromSoberApp
//
//  Created by David Regatos on 27/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import "NSDictionary+Secure.h"

@implementation NSDictionary (Secure)

- (id)valueForKey:(NSString *)key orDefaultValue:(id)defaultValue {
    return self[key] ? self[key] : defaultValue;
}

@end
