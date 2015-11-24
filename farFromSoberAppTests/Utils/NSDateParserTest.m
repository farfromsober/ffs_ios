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
//- (void)testNSDateToStringAndBackToNSDateShouldProduceTheSameDate  {
//    NSDate *now = [NSDate date];
//    NSString *nowString = [NSDate stringWithISO8601FormatDate:now];
//    NSDate *nowStringDate = [NSDate parseISO8601Date:nowString];
//    XCTAssertTrue([now isEqualToDate:nowStringDate], @"Date shouldn't change after date->string->date conversion");
//    XCTAssertTrue([now timeIntervalSinceDate:nowStringDate] == 0, @"Date shouldn't change after date->string->date conversion");
//}

- (void)testStringToNSDateAndBackToNSStringShouldProduceTheSameString  {
    NSString *now = [NSDate stringWithISO8601FormatDate:[NSDate date]];
    NSDate *nowDate = [NSDate parseISO8601Date:now];
    NSString *nowDateString = [NSDate stringWithISO8601FormatDate:nowDate];
    XCTAssertTrue([now isEqualToString:nowDateString], @"Date shouldn't change after date->string->date conversion");
}

@end
