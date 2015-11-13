//
//  Product.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "Product.h"

static NSString * const nameKey = @"";
static NSString * const detailKey = @"";
static NSString * const categoryKey = @"";
static NSString * const publishedKey = @"";
static NSString * const priceKey = @"";
static NSString * const sellerKey = @"";
static NSString * const stateKey = @"";

static NSString * const soldKey = @"";
static NSString * const sellingKey = @"";


@interface Product ()

@property (readwrite, nonatomic) NSString *name;
@property (readwrite, nonatomic) NSString *detail;           // = description
@property (readwrite, nonatomic) NSString *category;
@property (readwrite, nonatomic) NSDate *published;
@property (readwrite, nonatomic) NSNumber *price;
@property (readwrite, nonatomic) User *seller;
@property (readwrite, nonatomic) ProductState state;

@end

@implementation Product

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    #pragma mark - TODO: check dic has needed info
    if (dic) {
        Product *product = [[Product alloc] init];
        product.name = dic[nameKey];
        product.detail = dic[detailKey];
        product.category = dic[categoryKey];
        product.published = dic[publishedKey];
        product.price = dic[priceKey];
        product.seller = dic[sellerKey];
        product.state = [dic[stateKey] isEqualToString:soldKey] ? ProductState_Sold : ProductState_Selling;
        
        return product;
    }
    
    return nil;
}

#pragma mark - JSONCreator

- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    #pragma mark - TODO: check dic has needed info
    if (obj && [obj isKindOfClass:[self class]]) {
        Product *product = (Product *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[nameKey] = product.name;
        mDic[detailKey] = product.detail;
        mDic[categoryKey] = product.category;
        mDic[publishedKey] = product.published;
        mDic[priceKey] = product.price;
        mDic[sellerKey] = product.seller;
        mDic[stateKey] = product.state == ProductState_Sold ? soldKey : sellingKey;
        
        return [mDic copy];
    }
    
    return nil;
}

@end
