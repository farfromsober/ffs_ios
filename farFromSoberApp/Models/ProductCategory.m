//
//  Type.m
//  farFromSoberApp
//
//  Created by David Regatos on 14/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProductCategory.h"
#import "NSString+Validator.h"

static NSString * const indexKey = @"index";
static NSString * const nameKey = @"name";

@implementation ProductCategory

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    if (dic && [[self class] hasNeededInformation:dic]) {
        ProductCategory *category = [[ProductCategory alloc] init];
        category.index = dic[indexKey] ? [dic[indexKey] integerValue] : 0;
        category.name = dic[nameKey] ? dic[nameKey] : @"";
        
        return category;
    }
    
    return nil;
}

#pragma mark - JSONCreator
- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    if ([obj isKindOfClass:[self class]]) {
        ProductCategory *category = (ProductCategory *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[indexKey] = @(category.index);
        mDic[nameKey] = category.name;
        
        return [mDic copy];
    }
    return nil;
}

#pragma mark - Utils

+ (BOOL)hasNeededInformation:(NSDictionary *)dic {
    
     if (!dic[indexKey]) {
         return NO;
     } else if ([NSString isEmpty:dic[nameKey]]) {
         return NO;
     }
    
    return YES;
}

#pragma mark - Overriden

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return self.index == ((ProductCategory *)other).index;
    }
    
    return NO;
}

- (NSUInteger)hash {
    return self.index;
}



@end
