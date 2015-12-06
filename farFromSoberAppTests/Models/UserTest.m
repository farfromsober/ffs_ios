//
//  UserTest.m
//  farFromSoberApp
//
//  Created by David Regatos on 18/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"
#import "FakeModelObjects.h"

@interface UserTest : XCTestCase

@end

@implementation UserTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - JSON Parser

- (void)testUserInitializedWithNilDictionaryShouldBeNil  {
    User *user = [[User alloc] initWithJSON:nil];
    XCTAssertNil(user, @"If JSON dictionary is nil, 'User' object should be also nil");
}

- (void)testUserInitializedWithDictionaryWithNoUserIDShouldBeNil  {
    User *user = [[User alloc] initWithJSON:@{@"user":@{@"_id":@""}}];
    XCTAssertNil(user, @"If JSON dictionary has no id, 'user' object should be nil");
}

- (void)testUserInitializedWithDictionaryWithNoUsernameShouldBeNil  {
    User *user = [[User alloc] initWithJSON:@{@"user":@{@"username":@""}}];
    XCTAssertNil(user, @"If JSON dictionary has no username, 'user' object should be nil");
}

- (void)testUserInitializedWithDictionaryWithNoEmailShouldBeNil  {
    User *user = [[User alloc] initWithJSON:@{@"user":@{@"email":@""}}];
    XCTAssertNil(user, @"If JSON dictionary has no email, 'user' object should be nil");
}

- (void)testUserInitializedWithIdUsernameAndEmailShouldBeCreated  {
    User *user = [[User alloc] initWithJSON:@{@"user":@{@"id":@"12345", @"username":@"A name", @"email":@"email"}}];
    XCTAssertNotNil(user, @"If JSON dictionary has needed fields (id, username, and email), 'user' object should be created");
}

- (void)testUserCreatedShouldMatchInputFields  {
    NSDictionary *json = [FakeModelObjects fakeJSONUser];
    User *user = [[User alloc] initWithJSON:json];
    XCTAssertTrue([user.userId isEqualToNumber:json[@"user"][@"id"]], @"'userId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([user.username isEqualToString:json[@"user"][@"username"]], @"'username' should be equal tu json[\"username\"]");
    XCTAssertTrue([user.email isEqualToString:json[@"user"][@"email"]], @"'email' should be equal tu json[\"email\"]");
    XCTAssertTrue([user.firstName isEqualToString:json[@"user"][@"first_name"]], @"'firstName' should be equal tu json[\"first_name\"]");
    XCTAssertTrue([user.lastName isEqualToString:json[@"user"][@"last_name"]], @"'lastName' should be equal tu json[\"last_name\"]");
    XCTAssertTrue([user.latitude isEqualToString:json[@"latitude"]], @"'latitude' should be equal tu json[\"latitude\"]");
    XCTAssertTrue([user.longitude isEqualToString:json[@"longitude"]], @"'longitude' should be equal tu json[\"longitude\"]");
    XCTAssertTrue([user.city isEqualToString:json[@"city"]], @"'city' should be equal tu json[\"city\"]");
    XCTAssertTrue([user.state isEqualToString:json[@"state"]], @"'state' should be equal tu json[\"state\"]");
    XCTAssertTrue([[user.avatarURL absoluteString] isEqualToString:json[@"avatar"]], @"userId should be equal tu json[\"_id\"]");
}

#pragma mark - JSON Creator

- (void)testJSONCreationWithNilObjectShouldReturnNilJSON  {
    NSDictionary *json = [[User alloc] objectToJSON:nil];
    XCTAssertNil(json, @"If Object is nil, Dictionary should be also nil");
}

- (void)testJSONCreatedShouldMatchInputFields  {
    User *user = [FakeModelObjects fakeUserObject];
    NSDictionary *json = [[User alloc] objectToJSON:user];
    XCTAssertTrue([user.userId isEqualToNumber:json[@"id"]], @"'userId' should be equal tu json[\"_id\"]");
    XCTAssertTrue([user.username isEqualToString:json[@"username"]], @"'username' should be equal tu json[\"username\"]");
    XCTAssertTrue([user.email isEqualToString:json[@"email"]], @"'email' should be equal tu json[\"email\"]");
    XCTAssertTrue([user.firstName isEqualToString:json[@"first_name"]], @"'firstName' should be equal tu json[\"first_name\"]");
    XCTAssertTrue([user.lastName isEqualToString:json[@"last_name"]], @"'lastName' should be equal tu json[\"last_name\"]");
    XCTAssertTrue([user.latitude isEqualToString:json[@"latitude"]], @"'latitude' should be equal tu json[\"latitude\"]");
    XCTAssertTrue([user.longitude isEqualToString:json[@"longitude"]], @"'longitude' should be equal tu json[\"longitude\"]");
    XCTAssertTrue([user.city isEqualToString:json[@"city"]], @"'city' should be equal tu json[\"city\"]");
    XCTAssertTrue([user.state isEqualToString:json[@"state"]], @"'state' should be equal tu json[\"state\"]");
    XCTAssertTrue([[user.avatarURL absoluteString] isEqualToString:json[@"avatar"]], @"userId should be equal tu json[\"_id\"]");
}

@end
