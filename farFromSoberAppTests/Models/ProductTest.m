//
//  ProductTest.m
//  farFromSoberApp
//
//  Created by David Regatos on 18/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Product.h"
#import "User.h"
#import "ProductCategory.h"
#import "FakeModelObjects.h"

@interface ProductTest : XCTestCase

@end

@implementation ProductTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - JSON Parser

- (void)testProductInitializedWithNilDictionaryShouldBeNil  {
    Product *product = [[Product alloc] initWithJSON:nil];
    XCTAssertNil(product, @"If JSON dictionary is nil, 'Product' object should be also nil");
}

- (void)testProductInitializedWithDictionaryWithNoIDShouldBeNil  {
    Product *product = [[Product alloc] initWithJSON:@{@"_id":@""}];
    XCTAssertNil(product, @"If JSON dictionary has no id, 'product' object should be nil");
}

- (void)testProductInitializedWithDictionaryWithNoNameShouldBeNil  {
    Product *product = [[Product alloc] initWithJSON:@{@"name":@""}];
    XCTAssertNil(product, @"If JSON dictionary has no name, 'product' object should be nil");
}

- (void)testProductInitializedWithDictionaryWithNoPriceShouldBeNil  {
    Product *product = [[Product alloc] initWithJSON:@{@"price":@""}];
    XCTAssertNil(product, @"If JSON dictionary has no price, 'product' object should be nil");
}

- (void)testProductInitializedWithDictionaryWithNoSellerShouldBeNil  {
    Product *product = [[Product alloc] initWithJSON:@{@"seller":@""}];
    XCTAssertNil(product, @"If JSON dictionary has no price, 'product' object should be nil");
}

- (void)testUserInitializedWithIdUsernameAndEmailShouldBeCreated  {
    NSDictionary *dic = @{@"id":@"12345",
                          @"name":@"Luck Patrol",
                          @"price":@"125.50",
                          @"seller":[FakeModelObjects fakeJSONUser]
                          };
    Product *product = [[Product alloc] initWithJSON:dic];
    XCTAssertNotNil(product, @"If JSON dictionary has needed fields (id, username, and email), 'user' object should be created");
}

- (void)testProductInitializedWithDictionaryInWhichSellerIsNotADictionaryShouldBeNil  {
    Product *product = [[Product alloc] initWithJSON:@{@"id":@"12345",
                                                       @"name":@"Luck Patrol",
                                                       @"price":@"125.50",
                                                       @"seller":@""}];
    XCTAssertNil(product, @"If JSON valueForKey 'seller' is not a dictionary, 'product' object should be nil");
}

- (void)testProductCreatedShouldMatchInputFields {
    NSDictionary *json = [FakeModelObjects fakeJSONProduct];
    Product *product = [[Product alloc] initWithJSON:json];
    XCTAssertTrue([product.productId isEqualToString:json[@"id"]], @"'productId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([product.name isEqualToString:json[@"name"]], @"'name' should be equal tu json[\"name\"]");
    XCTAssertTrue([product.price isEqualToString:json[@"price"]], @"'price' should be equal tu json[\"email\"]");
    XCTAssertTrue([product.seller isEqual:[FakeModelObjects fakeUserObject]], @"'seller' should be equal tu json[\"seller\"]");
    XCTAssertTrue([product.detail isEqualToString:json[@"description"]], @"'detail' should be equal tu json[\"last_name\"]");
    XCTAssertTrue([product.published isEqualToDate:[FakeModelObjects fakePublishedDate]], @"'published' should be equal tu json[\"publised_date\"]");
    XCTAssertTrue([product.category isEqual:[FakeModelObjects fakeCategoryObject]], @"'category' should be equal tu json[\"category\"]");
    XCTAssertTrue([product.images count] == [json[@"images"] count], @"'images' count should be equal tu json[\"images\"] count");
    XCTAssertTrue([product.images isEqualToArray:[FakeModelObjects fakeImageUrls]], @"'images' array should be equal tu json[\"images\"] array");
    XCTAssertTrue(product.isSelling == [json[@"selling"] boolValue], @"'isSelling' should be equal tu json[\"selling\"]");
}

#pragma mark - JSON Creator

- (void)testJSONCreationWithNilObjectShouldReturnNilJSON  {
    NSDictionary *json = [[Product alloc] objectToJSON:nil];
    XCTAssertNil(json, @"If Object is nil, Dictionary should be also nil");
}

- (void)testJSONCreatedShouldMatchInputFields  {
    Product *product = [FakeModelObjects fakeProductObject];
    NSDictionary *json = [[Product alloc] objectToJSON:product];
    XCTAssertTrue([product.productId isEqualToString:json[@"_id"]], @"'productId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([product.name isEqualToString:json[@"name"]], @"'name' should be equal tu json[\"name\"]");
    XCTAssertTrue([product.price isEqualToString:json[@"price"]], @"'price' should be equal tu json[\"email\"]");
    XCTAssertTrue([[FakeModelObjects fakeJSONUser] isEqualToDictionary:json[@"seller"]],
                  @"'seller' should be equal tu json[\"seller\"]");
    XCTAssertTrue([product.detail isEqualToString:json[@"description"]], @"'detail' should be equal tu json[\"last_name\"]");
    XCTAssertTrue([product.published isEqualToDate:[FakeModelObjects fakePublishedDate]],
                  @"'published' should be equal tu json[\"publised_date\"]");
    XCTAssertTrue([[FakeModelObjects fakeJSONCategory] isEqualToDictionary:json[@"category"]],
                  @"'category' should be equal tu json[\"category\"]");
    XCTAssertTrue([product.images count] == [json[@"images"] count], @"'images' count should be equal tu json[\"images\"] count");
    XCTAssertTrue([[FakeModelObjects fakeImageStrings] isEqualToArray:json[@"images"]],
                  @"'images' array should be equal tu json[\"images\"] array");
    XCTAssertTrue(product.isSelling == [json[@"selling"] boolValue], @"'isSelling' should be equal tu json[\"selling\"]");
}


@end
