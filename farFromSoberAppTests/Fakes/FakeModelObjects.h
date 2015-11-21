//
//  FakeModelObjects.h
//  farFromSoberApp
//
//  Created by David Regatos on 19/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Product;
@class ProductCategory;
@class SavedSearch;
@class Transaction;

@interface FakeModelObjects : NSObject

+ (NSDictionary *)fakeJSONUser;
+ (User *)fakeUserObject;

+ (NSDictionary *)fakeJSONCategory;
+ (ProductCategory *)fakeCategoryObject;

+ (NSDictionary *)fakeJSONProduct;
+ (Product *)fakeProductObject;

+ (NSArray *)fakeImageStrings;
+ (NSArray *)fakeImageUrls;

+ (NSDate *)fakePublishedDate;
+ (NSString *)fakePublishedString;

+ (SavedSearch *)fakeSavedSearchObject;
+ (NSDictionary *)fakeJSONSavedSearch;

+ (Transaction *)fakeTransactionObject;
+ (NSDictionary *)fakeJSONTransaction;

@end
