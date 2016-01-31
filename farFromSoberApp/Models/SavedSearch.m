//
//  SavedSearch.m
//  farFromSoberApp
//
//  Created by David Regatos on 17/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "SavedSearch.h"
#import "User.h"
#import "ProductCategory.h"

static NSString * const idKey = @"id";
static NSString * const queryKey = @"query";
static NSString * const userKey = @"user";
static NSString * const categoryKey = @"category";

@implementation SavedSearch

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    if (dic && [[self class] hasNeededInformation:dic]) {
        SavedSearch *search = [[SavedSearch alloc] init];
        search.saveSearchId = dic[idKey] ? dic[idKey] : 0;
        search.query = dic[queryKey] ? dic[queryKey] : @"";
        search.user = [[User alloc] initWithJSON:dic[userKey]];
        search.category = dic[categoryKey] ? [[ProductCategory alloc] initWithJSON:dic[categoryKey]] : nil;
        
        return search;
    }
    
    return nil;
}

#pragma mark - JSONCreator
- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    if ([obj isKindOfClass:[self class]]) {
        SavedSearch *search = (SavedSearch *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[idKey] = search.saveSearchId;
        mDic[queryKey] = search.query;
        mDic[userKey] = [[User alloc] objectToJSON:search.user];
        mDic[categoryKey] = [[ProductCategory alloc] objectToJSON:search.category];
        
        return [mDic copy];
    }
    return nil;
}

#pragma mark - Utils

+ (BOOL)hasNeededInformation:(NSDictionary *)dic {
    
    if (!dic[idKey]) {
        return NO;
    } else if (![dic[userKey] isKindOfClass:[NSDictionary class]]) {
        return NO;
    } else if (![User hasNeededInformation:dic[userKey]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Overriden

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return self.saveSearchId == ((SavedSearch *)other).saveSearchId;
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.saveSearchId integerValue];
}

@end
