//
//  NSDate+Parser.h
//  farFromSoberApp
//
//  Created by David Regatos on 20/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Parser)

+ (NSDate *)parseISO8601Date:(NSString *)jsonDate;
+ (NSString *)stringWithISO8601FormatDate:(NSDate *)date;

@end
