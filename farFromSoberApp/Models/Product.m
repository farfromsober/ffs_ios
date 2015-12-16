//
//  Product.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "Product.h"
#import "User.h"
#import "ProductCategory.h"

#import "NSString+Validator.h"
#import "NSDate+Parser.h"

static NSString * const idKey = @"id";
static NSString * const nameKey = @"name";
static NSString * const detailKey = @"description";
static NSString * const categoryKey = @"category";
static NSString * const publishedKey = @"published_date";
static NSString * const priceKey = @"price";
static NSString * const sellerKey = @"seller";
static NSString * const statusKey = @"selling";
static NSString * const imagesKey = @"images";

@implementation Product

#pragma mark - Properties
-(NSString *)dateFormatted{
    if (self.published) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        return [@"published " stringByAppendingString:[dateFormatter stringFromDate:self.published]];
    }
    return @"";
}


#pragma mark - Storing & retriving

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.productId forKey:idKey];
    [encoder encodeObject:self.name forKey:nameKey];
    [encoder encodeObject:self.detail forKey:detailKey];
    [encoder encodeObject:self.price forKey:priceKey];
    [encoder encodeObject:self.seller forKey:sellerKey];
    [encoder encodeObject:self.published forKey:publishedKey];
    [encoder encodeObject:self.category forKey:categoryKey];
    [encoder encodeObject:self.images forKey:imagesKey];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.productId = [decoder decodeObjectForKey:idKey];
        self.name = [decoder decodeObjectForKey:nameKey];
        self.detail = [decoder decodeObjectForKey:detailKey];
        self.price = [decoder decodeObjectForKey:priceKey];
        self.seller = [decoder decodeObjectForKey:sellerKey];
        self.published = [decoder decodeObjectForKey:publishedKey];
        self.category = [decoder decodeObjectForKey:categoryKey];
        self.images = [decoder decodeObjectForKey:imagesKey];
    }
    return self;
}

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    if (dic && [[self class] hasNeededInformation:dic]) {
        Product *product = [[Product alloc] init];
        product.isSelling = [dic[statusKey] boolValue] == YES ? YES : NO;
        product.productId = dic[idKey] ? dic[idKey] : @"";
        product.name = dic[nameKey] ? dic[nameKey] : @"";
        product.detail = dic[detailKey] ? dic[detailKey] : @"";
        product.category = dic[categoryKey] ? [[ProductCategory alloc] initWithJSON:dic[categoryKey]] : nil;
        product.seller = [[User alloc] initWithJSON:dic[sellerKey]];
        
        if (dic[priceKey]){
            // le quitamos el .0 del final
            product.price = [dic[priceKey] substringToIndex:[dic[priceKey] length]-2];
        } else {
            product.price = @"";
        }
        
        if (dic[publishedKey]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"];
            product.published = [dateFormatter dateFromString:dic[publishedKey]];
        } else {
            product.published = nil;
        }
        
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        if ([dic[imagesKey] isKindOfClass:[NSArray class]]) {
            for (NSString *urlString in dic[imagesKey]) {
                NSURL *url = [NSURL URLWithString:urlString];
                [mArr addObject:url];
            }
        }
        product.images = [mArr copy];
        
        return product;
    }
    
    return nil;
}

#pragma mark - JSONCreator

- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    if (obj && [obj isKindOfClass:[self class]]) {
        Product *product = (Product *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[statusKey] = product.isSelling == YES ? @(YES) : @(NO);
        mDic[idKey] = product.productId;
        mDic[nameKey] = product.name;
        mDic[detailKey] = product.detail;
        mDic[categoryKey] = [[ProductCategory alloc] objectToJSON:product.category];
        mDic[publishedKey] = [NSDate stringWithISO8601FormatDate:product.published];
        mDic[priceKey] = product.price;
        mDic[sellerKey] = [[User alloc] objectToJSON:product.seller];
        
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        for (NSURL *url in product.images) {
            [mArr addObject:[url absoluteString]];
        }
        mDic[imagesKey] = [mArr copy];
        
        return [mDic copy];
    }
    
    return nil;
}

#pragma mark - Utils

+ (BOOL)hasNeededInformation:(NSDictionary *)dic {

    if ([NSString isEmpty:dic[idKey]]) {
        return NO;
    } else if ([NSString isEmpty:dic[nameKey]]) {
        return NO;
    } else if ([NSString isEmpty:dic[priceKey]]) {
        return NO;
    } else if (![dic[sellerKey] isKindOfClass:[NSDictionary class]]) {
        return NO;
    } else if (![User hasNeededInformation:dic[sellerKey]]) {
    //    return NO;
    }
    
    return YES;
}




#pragma mark - Overriden

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return [self.productId isEqualToString:((Product *)other).productId];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.productId integerValue];
}


@end
