//
//  FakeModelObjects.m
//  farFromSoberApp
//
//  Created by David Regatos on 19/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "FakeModelObjects.h"
#import "User.h"
#import "Product.h"
#import "ProductCategory.h"
#import "Transaction.h"
#import "SavedSearch.h"

#import "NSDate+Parser.h"

@implementation FakeModelObjects

#pragma mark - User

+ (NSDictionary *)fakeJSONUser {
    return @{@"id": @(123456),
             @"user": @{
                 @"id": @(123456),
                 @"password": @"pbkdf2_sha256$20000$XwPGBxasqiZ5$ARHLY+JUFgyVLi61+vWcHDj+zkN/KYZ6SssPYjYGE2g=",
                 @"last_login": @"2015-12-06T10:42:46.450688Z",
                 @"is_superuser": @(NO),
                 @"username": @"dregatos",
                 @"first_name": @"David",
                 @"last_name": @"Regatos",
                 @"email": @"david.regatos@gmail.com",
                 @"is_staff": @(NO),
                 @"is_active": @(YES),
                 @"date_joined": @"2015-12-02T19:42:26Z",
                 @"groups": @[],
                 @"user_permissions": @[]
             },
             @"avatar": @"http://www.sheffield.com/wp-content/uploads/2013/06/placeholder.png",
             @"latitude": @"40.375762",
             @"longitude": @"-3.599271",
             @"city": @"Madrid",
             @"state": @"Madrid",
             @"sales": @(11),
             };
}

+ (User *)fakeUserObject {
    User *user = [[User alloc] init];
    user.avatarURL = [NSURL URLWithString:@"http://www.sheffield.com/wp-content/uploads/2013/06/placeholder.png"];
    user.userId = @(123456);
    user.firstName = @"David";
    user.lastName = @"Regatos";
    user.username = @"dregatos";
    user.email = @"david.regatos@gmail.com";
    user.latitude = @"40.375762";
    user.longitude = @"-3.599271";
    user.city = @"Madrid";
    user.state = @"Madrid";
    user.sales = @(11);
    
    return user;
}

#pragma mark - Category

+ (NSDictionary *)fakeJSONCategory {
    return @{@"index": @(0), @"name": @"Category_1"};
}

+ (ProductCategory *)fakeCategoryObject {
    ProductCategory *product = [[ProductCategory alloc] init];
    product.index = 0;
    product.name = @"Category_1";
    return product;
}

#pragma mark - Utils

+ (NSDictionary *)fakeJSONProduct {
    
    return @{
             @"id": @"5649b6eae9a246eed43f0174",
             @"name": @"tempor in laboris",
             @"description": @"mollit nisi nisi ea exercitation deserunt anim et cupidatat fugiat ullamco fugiat amet",
             @"published_date": [self fakePublishedString],
             @"selling": @(true),
             @"price": @"387.96",
             @"seller": [self fakeJSONUser],
             @"category": [self fakeJSONCategory],
             @"images": [self fakeImageStrings]
             };
}

+ (Product *)fakeProductObject {
    Product *product = [[Product alloc] init];
    product.productId = @"5649b6eae9a246eed43f0174";
    product.name = @"tempor in laboris";
    product.detail = @"mollit nisi nisi ea exercitation deserunt anim et cupidatat fugiat ullamco fugiat amet";
    product.published = [self fakePublishedDate];
    product.isSelling = YES;
    product.price = @"387.96";
    product.seller = [self fakeUserObject];
    product.category = [self fakeCategoryObject];
    product.images = [self fakeImageUrls];
    
    return product;
}

+ (NSArray *)fakeImageStrings {
    return @[@"http://placehold.it/350x350", @"http://placehold.it/350x350"];
}

+ (NSArray *)fakeImageUrls {
    return @[[NSURL URLWithString:@"http://placehold.it/350x350"],
             [NSURL URLWithString:@"http://placehold.it/350x350"]];
}

+ (NSDate *)fakePublishedDate {
    return [NSDate parseISO8601Date:[self fakePublishedString]];
}

+ (NSString *)fakePublishedString {
    return @"2015-11-02T15:16:29+0100";
}

+ (SavedSearch *)fakeSavedSearchObject {
    SavedSearch *search = [[SavedSearch alloc] init];
    search.saveSearchId = @"5649c39ba323833e50d48d58";
    search.query = @"ipsum incididunt esse";
    search.user = [self fakeUserObject];
    search.category = [self fakeCategoryObject];
    
    return search;
}

+ (NSDictionary *)fakeJSONSavedSearch {
    return @{
             @"id": @"5649c39ba323833e50d48d58",
             @"query": @"ipsum incididunt esse",
             @"user":[self fakeJSONUser],
             @"category":[self fakeJSONCategory]
             };
}

+ (Transaction *)fakeTransactionObject {
    Transaction *transaction = [[Transaction alloc] init];
    transaction.transactionId = @"5649c11c3fc81426a5b17fbc";
    transaction.product = [self fakeProductObject];
    transaction.buyer = [self fakeUserObject];
    transaction.date = [self fakePublishedDate];
    
    return transaction;
}

+ (NSDictionary *)fakeJSONTransaction {
    return @{
             @"id": @"5649c11c3fc81426a5b17fbc",
             @"product": [self fakeJSONProduct],
             @"buyer":[self fakeJSONUser],
             @"date": [self fakePublishedString]
             };
}


@end
