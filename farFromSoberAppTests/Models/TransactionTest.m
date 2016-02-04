//
//  TransactionTest.m
//  farFromSoberApp
//
//  Created by David Regatos on 18/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Transaction.h"
#import "User.h"
#import "Product.h"
#import "FakeModelObjects.h"

@interface TransactionTest : XCTestCase

@end

@implementation TransactionTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - JSON Parser

- (void)testTransactionInitializedWithNilDictionaryShouldBeNil  {
    Transaction *transaction = [[Transaction alloc] initWithJSON:nil];
    XCTAssertNil(transaction, @"If JSON dictionary is nil, 'Transaction' object should be also nil");
}

- (void)testTransactionInitializedWithDictionaryWithNoIDShouldBeNil  {
    Transaction *transaction = [[Transaction alloc] initWithJSON:@{@"id":@""}];
    XCTAssertNil(transaction, @"If JSON dictionary has no id, 'Transaction' object should be nil");
}

- (void)testTransactionInitializedWithDictionaryWithNoProductShouldBeNil  {
    Transaction *transaction = [[Transaction alloc] initWithJSON:@{@"product":@""}];
    XCTAssertNil(transaction, @"If JSON dictionary has no id, 'Transaction' object should be nil");
}

- (void)testTransactionInitializedWithDictionaryWithNoBuyerShouldBeNil  {
    Transaction *transaction = [[Transaction alloc] initWithJSON:@{@"buyer":@""}];
    XCTAssertNil(transaction, @"If JSON dictionary has no id, 'Transaction' object should be nil");
}

- (void)testTransactionInitializedWithIdAndUserShouldBeCreated  {
    NSDictionary *dic = @{@"id":@"12345",
                          @"product": [FakeModelObjects fakeJSONProduct],
                          @"buyer":[FakeModelObjects fakeJSONUser]
                          };
    Transaction *transaction = [[Transaction alloc] initWithJSON:dic];
    XCTAssertNotNil(transaction, @"If JSON dictionary has needed fields (id, product and buyer), 'Transaction' object should be created");
}

- (void)testTransactionCreatedShouldMatchInputFields  {
    NSDictionary *json = [FakeModelObjects fakeJSONTransaction];
    Transaction *transaction = [[Transaction alloc] initWithJSON:json];
    XCTAssertTrue([transaction.transactionId isEqualToString:json[@"id"]], @"'saveSearchId' should be equal tu json[\"id\"]");
    XCTAssertTrue([transaction.product isEqual:[FakeModelObjects fakeProductObject]], @"'product' should be equal tu json[\"product\"]");
    XCTAssertTrue([transaction.buyer isEqual:[FakeModelObjects fakeUserObject]], @"'buyer' should be equal tu json[\"buyer\"]");
    XCTAssertTrue([transaction.date isEqualToDate:[FakeModelObjects fakePublishedDate]], @"'date' should be equal tu json[\"date\"]");
}

#pragma mark - JSON Creator

- (void)testJSONCreationWithNilObjectShouldReturnNilJSON  {
    NSDictionary *json = [[Transaction alloc] objectToJSON:nil];
    XCTAssertNil(json, @"If Object is nil, Dictionary should be also nil");
}

- (void)testJSONCreatedShouldMatchInputFields  {
    Transaction *transaction = [FakeModelObjects fakeTransactionObject];
    NSDictionary *json = [[Transaction alloc] objectToJSON:transaction];
    XCTAssertTrue([transaction.transactionId isEqualToString:json[@"id"]], @"'saveSearchId' should be equal tu json[\"id\"]");
    XCTAssertTrue([[FakeModelObjects fakeJSONUser] isEqualToDictionary:json[@"buyer"]],
                  @"'buyer' should be equal tu json[\"buyer\"]");
    XCTAssertTrue([[FakeModelObjects fakeJSONProduct] isEqualToDictionary:json[@"product"]],
                  @"'product' should be equal tu json[\"product\"]");
    XCTAssertTrue([[FakeModelObjects fakePublishedString] isEqualToString:json[@"date"]],
                  @"'date' should be equal tu json[\"date\"]");
}


@end
