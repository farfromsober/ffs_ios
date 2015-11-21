//
//  SavedSearch.h
//  farFromSoberApp
//
//  Created by David Regatos on 17/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONCreator.h"
#import "JSONParser.h"

@class User;
@class ProductCategory;

@interface SavedSearch : NSObject <JSONCreator, JSONParser>

@property (copy, nonatomic) NSString *saveSearchId;
@property (copy, nonatomic) NSString *query;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) ProductCategory *category;

@end
