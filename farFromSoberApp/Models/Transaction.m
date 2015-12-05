//
//  Transaction.m
//  farFromSoberApp
//
//  Created by David Regatos on 17/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "Transaction.h"
#import "Product.h"
#import "User.h"

#import "NSDate+Parser.h"

static NSString * const idKey = @"_id";
static NSString * const productKey = @"product";
static NSString * const buyerKey = @"buyer";
static NSString * const dateKey = @"date";

@implementation Transaction

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    if (dic && [[self class] hasNeededInformation:dic]) {
        Transaction *transaction = [[Transaction alloc] init];
        transaction.transactionId = dic[idKey] ? dic[idKey] : 0;
        transaction.product = [[Product alloc] initWithJSON:dic[productKey]];
        transaction.buyer = [[User alloc] initWithJSON:dic[buyerKey]];
        transaction.date = dic[dateKey] ? [NSDate parseISO8601Date:dic[dateKey]] : nil;
        
        return transaction;
    }
    
    return nil;
}

#pragma mark - JSONCreator
- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    if ([obj isKindOfClass:[self class]]) {
        Transaction *transaction = (Transaction *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[idKey] = transaction.transactionId;
        mDic[productKey] = [[Product alloc] objectToJSON:transaction.product];
        mDic[buyerKey] = [[User alloc] objectToJSON:transaction.buyer];
        mDic[dateKey] = [NSDate stringWithISO8601FormatDate:transaction.date];
        
        return [mDic copy];
    }
    return nil;
}

#pragma mark - Utils

+ (BOOL)hasNeededInformation:(NSDictionary *)dic {
    if (!dic[idKey]) {
        return NO;
    } else if (![dic[buyerKey] isKindOfClass:[NSDictionary class]]) {
        return NO;
    } else if (![User hasNeededInformation:dic[buyerKey]]) {
        return NO;
    }  else if (![dic[productKey] isKindOfClass:[NSDictionary class]]) {
        return NO;
    } else if (![Product hasNeededInformation:dic[productKey]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Overriden

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return self.transactionId == ((Transaction *)other).transactionId;
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.transactionId integerValue];
}

@end
