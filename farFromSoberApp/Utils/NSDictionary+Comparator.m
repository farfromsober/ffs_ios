//
//  NSDictionary+Comparator.m
//  farFromSoberApp
//
//  Created by David Regatos on 20/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NSDictionary+Comparator.h"

@implementation NSDictionary (Comparator)

- (BOOL)containsSameKeyAndValues:(NSDictionary *)other {
    
    if (!other || [other.allKeys count] != [self.allKeys count]) {
        return NO;
    }
    
    __block BOOL hasSame = YES;
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if (![[other objectForKey:key] isEqual:obj]) {
            *stop = YES;
            hasSame = NO;
            return;
        }
    }];
    
    return hasSame;
}


@end
