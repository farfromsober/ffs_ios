//
//  NSDateParserTest.m
//  farFromSoberApp
//
//  Created by David Regatos on 24/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Parser.h"

@interface NSDateParserTest : XCTestCase

@end

@implementation NSDateParserTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// NOTE: the +dateWithString: method does not maintain sub-second precision.
- (void)testNSDateToStringAndBackToNSDateShouldProduceTheSameDate  {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [NSLocale currentLocale];
    df.timeZone = [NSTimeZone systemTimeZone];
    df.dateFormat = @"yyyy-MM-dd";
    NSDate *now = [df dateFromString:@"2016-01-29"];
    NSString *nowString = [NSDate stringWithSimpleFormatDate:now];
    NSDate *nowStringDate = [NSDate parseSimpleDate:nowString];
    XCTAssertTrue([now isEqualToDate:nowStringDate], @"Date shouldn't change after date->string->date conversion");
    XCTAssertTrue([now timeIntervalSinceDate:nowStringDate] == 0, @"Date shouldn't change after date->string->date conversion");
}

- (void)testStringToNSDateAndBackToNSStringShouldProduceTheSameString  {
    NSString *now = @"2016-01-29"; // [NSDate stringWithSimpleFormatDate:[NSDate date]];
    NSDate *nowDate = [NSDate parseSimpleDate:now];
    NSString *nowDateString = [NSDate stringWithSimpleFormatDate:nowDate];
    XCTAssertTrue([now isEqualToString:nowDateString], @"Date shouldn't change after date->string->date conversion");
}

@end
