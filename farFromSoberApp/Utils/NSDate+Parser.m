//
//  NSDate+Parser.m
//  farFromSoberApp
//
//  Created by David Regatos on 20/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NSDate+Parser.h"

static NSString const *SIMPLE_DATE_FORMATTER = @"simple_date_formatter";

typedef NS_ENUM(NSInteger, DateFormatterType) {
    DateFormatterType_Simple,
    DateFormatterType_ISO8601
};

@implementation NSDate (Parser)

+ (NSDate *)parseSimpleDate:(NSString *)jsonDate {
    NSDateFormatter *df = [self formatter:DateFormatterType_Simple];
    return [df dateFromString:jsonDate];;
}

+ (NSString *)stringWithSimpleFormatDate:(NSDate *)date {
    NSDateFormatter *df = [self formatter:DateFormatterType_Simple];
    return [df stringFromDate:date];
}

+ (NSDate *)parseISO8601Date:(NSString *)jsonDate {
    NSDateFormatter *df = [self formatter:DateFormatterType_ISO8601];
    return [df dateFromString:jsonDate];;
}

+ (NSString *)stringWithISO8601FormatDate:(NSDate *)date {
    NSDateFormatter *df = [self formatter:DateFormatterType_ISO8601];
    return [df stringFromDate:date];
}

+ (NSDateFormatter *)formatter:(DateFormatterType)type {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [NSLocale currentLocale];
    df.timeZone = [NSTimeZone systemTimeZone];
    switch (type) {
        case DateFormatterType_Simple:
            df.dateFormat = [self SimpleFormat];
            break;
        case DateFormatterType_ISO8601:
            df.dateFormat = [self ISO8601Format];
            break;
        default:
            break;
    }
    return df;
}

+ (NSString *)ISO8601Format {
    return @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ";
}

+ (NSString *)SimpleFormat {
    return @"yyyy-MM-dd";
}

@end
