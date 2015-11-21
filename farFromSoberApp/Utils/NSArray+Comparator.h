//
//  NSArray+Comparator.h
//  farFromSoberApp
//
//  Created by David Regatos on 20/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Comparator)

- (BOOL)containsAllObjects:(id)anObject;
- (BOOL)containsSameStrings:(NSArray *)anObject;
- (BOOL)containsSameURLs:(NSArray *)anObject;

@end
