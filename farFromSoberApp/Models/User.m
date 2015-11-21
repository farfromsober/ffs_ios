//
//  User.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "User.h"
#import "NSString+Validator.h"

static NSString * const salesKey = @"sales";
static NSString * const idKey = @"_id";
static NSString * const firstNameKey = @"first_name";
static NSString * const lastNameKey = @"last_name";
static NSString * const emailKey = @"email";
static NSString * const usernameKey = @"username";
static NSString * const cityKey = @"city";
static NSString * const stateKey = @"state";
static NSString * const latitudeKey = @"latitude";
static NSString * const longitudeKey = @"longitude";
static NSString * const avatarKey = @"avatar";

@implementation User

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    // Doble comprobación, dos condones mejor que uno...
    if (dic && [[self class] hasNeededInformation:dic]) {
        User *user = [[User alloc] init];
        user.sales = dic[salesKey] ? [dic[salesKey] integerValue] : 0;
        user.userId = dic[idKey] ? dic[idKey] : @"";
        user.firstName = dic[firstNameKey] ? dic[firstNameKey] : @"";
        user.lastName = dic[lastNameKey] ? dic[lastNameKey] : @"";
        user.email = dic[emailKey] ? dic[emailKey] : @"";
        user.username = dic[usernameKey] ? dic[usernameKey] : @"";
        user.city = dic[cityKey] ? dic[cityKey] : @"";
        user.state = dic[stateKey] ? dic[stateKey] : @"";
        user.latitude = dic[latitudeKey] ? dic[latitudeKey] : @"";
        user.longitude = dic[longitudeKey] ? dic[longitudeKey] : @"";
        user.avatarURL = dic[avatarKey] ? [NSURL URLWithString:dic[avatarKey]] : [NSURL URLWithString:@""];

        return user;
    }
    
    return nil;
}

#pragma mark - JSONCreator

- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    if (obj && [obj isKindOfClass:[self class]]) {
        User *user = (User *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[salesKey] = user.sales ? @(user.sales) : @(0);
        mDic[idKey] = user.userId ? user.userId : @"";
        mDic[firstNameKey] = user.firstName ? user.firstName : @"";
        mDic[lastNameKey] = user.lastName ? user.lastName : @"";
        mDic[emailKey] = user.email ? user.email : @"";
        mDic[usernameKey] = user.username ? user.username : @"";
        mDic[cityKey] = user.city ? user.city : @"";
        mDic[stateKey] = user.state ? user.state : @"";
        mDic[latitudeKey] = user.latitude ? user.latitude : @"";
        mDic[longitudeKey] = user.longitude ? user.longitude : @"";
        mDic[avatarKey] = user.avatarURL ? [user.avatarURL absoluteString] : @"";

        return [mDic copy];
    }
    
    return nil;
}

#pragma mark - Utils

+ (BOOL)hasNeededInformation:(NSDictionary *)dic {
    
     if ([NSString isEmpty:dic[idKey]]) {
         return NO;
     } else if ([NSString isEmpty:dic[emailKey]]) {
         return NO;
     } else if ([NSString isEmpty:dic[usernameKey]]) {
         return NO;
     }
    
    return YES;
}

#pragma mark - Overriden

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return [self.userId isEqualToString:((User *)other).userId];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.userId integerValue];
}



@end
