//
//  NSDate+Parser.m
//  farFromSoberApp
//
//  Created by David Regatos on 20/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NSDate+Parser.h"

@implementation NSDate (Parser)

+ (NSDate *)parseISO8601Date:(NSString *)jsonDate {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setTimeZone:[NSTimeZone systemTimeZone]];
//    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:[self ISO8601Format]];      // WE NEED TO MATCH THE FORMAT
    return [df dateFromString:jsonDate];;
}

+ (NSString *)stringWithISO8601FormatDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setTimeZone:[NSTimeZone systemTimeZone]];
//    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:[self ISO8601Format]];
    return [df stringFromDate:date];
}

+ (NSString *)ISO8601Format {
   return @"yyyy-MM-dd'T'HH:mm:ssZ";
}

@end
