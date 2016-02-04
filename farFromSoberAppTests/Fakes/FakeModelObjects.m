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
    return @{@"id": @(6),
             @"user": @{ @"username": @"dregatos",
                         @"first_name": @"David",
                         @"last_name": @"Regatos",
                         @"email": @"david.regatos@gmail.com"
                        },
             @"avatar": @"http://www.sheffield.com/wp-content/uploads/2013/06/placeholder.png",
             @"latitude": @"41.4179636",
             @"longitude": @"-3.599271",
             @"city": @"Barcelona",
             @"state": @"Spain",
             @"sales": @(1)
            };
}

+ (User *)fakeUserObject {
    User *user = [[User alloc] init];
    user.avatarURL = [NSURL URLWithString:@"http://www.sheffield.com/wp-content/uploads/2013/06/placeholder.png"];
    user.userId = @(6);
    user.firstName = @"David";
    user.lastName = @"Regatos";
    user.username = @"dregatos";
    user.email = @"david.regatos@gmail.com";
    user.latitude = @"41.4179636";
    user.longitude = @"-3.599271";
    user.city = @"Barcelona";
    user.state = @"Spain";
    user.sales = @(1);
    
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
             @"category": [self fakeJSONCategory],
             @"seller": [self fakeJSONUser],
             @"price": @"387.96",
             @"images": [self fakeImageStrings],
             @"name": @"tempor in laboris",
             @"description": @"mollit nisi nisi ea exercitation deserunt anim et cupidatat fugiat ullamco fugiat amet",
             @"published_date": [self fakePublishedString],
             @"selling": @(true),
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
    return [NSDate parseSimpleDate:[self fakePublishedString]];
}

+ (NSString *)fakePublishedString {
    return @"2016-01-24";
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
    transaction.transactionId = @"56";
    transaction.product = [self fakeProductObject];
    transaction.buyer = [self fakeUserObject];
    transaction.date = [self fakePublishedDate];
    
    return transaction;
}

+ (NSDictionary *)fakeJSONTransaction {
    return @{
             @"id": @"56",
             @"product": [self fakeJSONProduct],
             @"buyer":[self fakeJSONUser],
             @"date": [self fakePublishedString]
             };
}


@end
