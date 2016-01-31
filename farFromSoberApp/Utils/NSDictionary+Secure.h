//
//  NSDictionary+Secure.h
//  farFromSoberApp
//
//  Created by David Regatos on 27/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Secure)

- (id)valueForKey:(NSString *)key orDefaultValue:(id)defaultValue;

@end
