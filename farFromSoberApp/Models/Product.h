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

typedef NS_ENUM(NSInteger, ProductState) {
    ProductState_Selling,
    ProductState_Sold,
};

@interface Product : NSObject <JSONParser, JSONCreator>

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *detail;      // = description
@property (readonly, nonatomic) NSString *category;
@property (readonly, nonatomic) NSDate *published;
@property (readonly, nonatomic) NSNumber *price;
@property (readonly, nonatomic) User *seller;
@property (readonly, nonatomic) ProductState state;

@end
