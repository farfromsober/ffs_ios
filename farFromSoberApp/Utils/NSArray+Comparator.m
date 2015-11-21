//
//  NSArray+Comparator.m
//  farFromSoberApp
//
//  Created by David Regatos on 20/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NSArray+Comparator.h"

@implementation NSArray (Comparator)

- (BOOL)containsAllObjects:(id)anObject {
    return [[NSSet setWithArray: anObject] isSubsetOfSet:[NSSet setWithArray: self]];
}

- (BOOL)containsSameStrings:(NSArray *)anObject {
    
    for (id obj1 in self) {
        if (![obj1 isKindOfClass:[NSString class]]) {
            return NO;
        }
        
        for (id obj2 in anObject) {
            if (![obj2 isKindOfClass:[NSString class]]) {
                return NO;
            }
            
            if (![obj1 isEqualToString:obj2]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)containsSameURLs:(NSArray *)anObject {
    
    for (id obj1 in self) {
        if (![obj1 isKindOfClass:[NSURL class]]) {
            return NO;
        }
        
        for (id obj2 in anObject) {
            if (![obj2 isKindOfClass:[NSURL class]]) {
                return NO;
            }
            
            if (![[obj1 absoluteString] isEqualToString:[obj2 absoluteString]]) {
                return NO;
            }
        }
    }
    
    return YES;
}



@end
