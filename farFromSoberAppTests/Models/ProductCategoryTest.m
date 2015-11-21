//
//  ProductCategoryTest.m
//  farFromSoberApp
//
//  Created by David Regatos on 18/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductCategory.h"
#import "FakeModelObjects.h"

@interface ProductCategoryTest : XCTestCase

@end

@implementation ProductCategoryTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - JSON Parser

- (void)testCategoryInitializedWithNilDictionaryShouldBeNil  {
    ProductCategory *category = [[ProductCategory alloc] initWithJSON:nil];
    XCTAssertNil(category, @"If JSON dictionary is nil, 'ProductCategory' object should be also nil");
}

/*
- (void)testCategoryInitializedWithDictionaryWithNoIndexShouldBeNil  {
    ProductCategory *category = [[ProductCategory alloc] initWithJSON:@{@"index":@(0)}];
    XCTAssertNil(category, @"If JSON dictionary has no name, 'category' object should be nil");
}
 */

- (void)testCategoryInitializedWithDictionaryWithNoNameShouldBeNil  {
    ProductCategory *category = [[ProductCategory alloc] initWithJSON:@{@"name":@""}];
    XCTAssertNil(category, @"If JSON dictionary has no name, 'category' object should be nil");
}

- (void)testCategoryInitializedWithIdAndNameShouldBeCreated  {
    ProductCategory *category = [[ProductCategory alloc] initWithJSON:@{@"_id":@"", @"name":@""}];
    XCTAssertNil(category, @"If JSON dictionary has no name, 'category' object should be nil");
}

- (void)testUserCreatedShouldMatchInputFields  {
    NSDictionary *json = [FakeModelObjects fakeJSONCategory];
    ProductCategory *product = [[ProductCategory alloc] initWithJSON:json];
    XCTAssertTrue(product.index  == [json[@"_id"] integerValue], @"'indext' should be equal tu json[\"index\"]");
    XCTAssertTrue([product.name isEqualToString:json[@"name"]], @"'name' should be equal tu json[\"name\"]");
}

#pragma mark - JSON Creator

- (void)testJSONCreationWithNilObjectShouldReturnNilJSON  {
    NSDictionary *json = [[ProductCategory alloc] objectToJSON:nil];
    XCTAssertNil(json, @"If Object is nil, Dictionary should be also nil");
}

- (void)testJSONCreatedShouldMatchInputFields  {
    ProductCategory *category = [FakeModelObjects fakeCategoryObject];
    NSDictionary *json = [[ProductCategory alloc] objectToJSON:category];
    XCTAssertTrue(category.index == [json[@"index"] integerValue], @"'index' should be equal tu json[\"index\"]");
    XCTAssertTrue([category.name isEqualToString:json[@"name"]], @"'name' should be equal tu json[\"name\"]");
}

@end
