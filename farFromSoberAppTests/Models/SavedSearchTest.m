//
//  SavedSearchTest.m
//  farFromSoberApp
//
//  Created by David Regatos on 18/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SavedSearch.h"
#import "User.h"
#import "ProductCategory.h"
#import "FakeModelObjects.h"
#import "NSDictionary+Comparator.h"

@interface SavedSearchTest : XCTestCase

@end

@implementation SavedSearchTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - JSON Parser

- (void)testSavedSearchInitializedWithNilDictionaryShouldBeNil  {
    SavedSearch *search = [[SavedSearch alloc] initWithJSON:nil];
    XCTAssertNil(search, @"If JSON dictionary is nil, 'SavedSearch' object should be also nil");
}

- (void)testSavedSearchInitializedWithDictionaryWithNoIDShouldBeNil  {
    SavedSearch *search = [[SavedSearch alloc] initWithJSON:@{@"_id":@""}];
    XCTAssertNil(search, @"If JSON dictionary has no id, 'SavedSearch' object should be nil");
}

- (void)testSavedSearchInitializedWithDictionaryWithNoUserShouldBeNil  {
    SavedSearch *search = [[SavedSearch alloc] initWithJSON:@{@"user":@""}];
    XCTAssertNil(search, @"If JSON dictionary has no user, 'SavedSearch' object should be nil");
}

- (void)testUserInitializedWithIdAndUserShouldBeCreated  {
    NSDictionary *dic = @{@"_id":@"12345",
                          @"user":[FakeModelObjects fakeJSONUser]
                          };
    SavedSearch *search = [[SavedSearch alloc] initWithJSON:dic];
    XCTAssertNotNil(search, @"If JSON dictionary has needed fields (id and user), 'SavedSearch' object should be created");
}

- (void)testSavedSearchCreatedShouldMatchInputFields  {
    NSDictionary *json = [FakeModelObjects fakeJSONSavedSearch];
    SavedSearch *search = [[SavedSearch alloc] initWithJSON:json];
    XCTAssertTrue([search.saveSearchId isEqualToString:json[@"_id"]], @"'saveSearchId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([search.saveSearchId isEqualToString:json[@"_id"]], @"'saveSearchId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([search.user isEqual:[FakeModelObjects fakeUserObject]], @"'seller' should be equal tu json[\"user\"]");
    XCTAssertTrue([search.category isEqual:[FakeModelObjects fakeCategoryObject]], @"'category' should be equal tu json[\"category\"]");
}

#pragma mark - JSON Creator

- (void)testJSONCreationWithNilObjectShouldReturnNilJSON  {
    NSDictionary *json = [[SavedSearch alloc] objectToJSON:nil];
    XCTAssertNil(json, @"If Object is nil, Dictionary should be also nil");
}

- (void)testJSONCreatedShouldMatchInputFields  {
    SavedSearch *search = [FakeModelObjects fakeSavedSearchObject];
    NSDictionary *json = [[SavedSearch alloc] objectToJSON:search];
    XCTAssertTrue([search.saveSearchId isEqualToString:json[@"_id"]], @"'saveSearchId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([search.query isEqualToString:json[@"query"]], @"'query' should be equal tu json[\"query\"]");
    XCTAssertTrue([[FakeModelObjects fakeJSONUser] containsSameKeyAndValues:json[@"user"]],
                  @"'user' should be equal tu json[\"user\"]");
    XCTAssertTrue([[FakeModelObjects fakeJSONCategory] containsSameKeyAndValues:json[@"category"]],
                  @"'category' should be equal tu json[\"category\"]");
}

@end


