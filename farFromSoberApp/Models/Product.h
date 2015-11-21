//
//  Product.h
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import "JSONCreator.h"

@class User;
@class ProductCategory;

@interface Product : NSObject <JSONParser, JSONCreator>

@property (nonatomic) BOOL isSelling;

@property (copy, nonatomic) NSString *productId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detail;      // = description
@property (copy, nonatomic) NSString *price;

@property (strong, nonatomic) User *seller;
@property (strong, nonatomic) NSDate *published;
@property (strong, nonatomic) ProductCategory *category;

// TODO: Array of images
@property (copy, nonatomic) NSArray *images;      // array of NSURLs !!!!

@end
