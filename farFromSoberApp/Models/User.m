//
//  User.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "User.h"

static NSString * const activeKey = @"";
static NSString * const avatarKey = @"";
static NSString * const firstNameKey = @"";
static NSString * const lastNameKey = @"";
static NSString * const emailKey = @"";
static NSString * const usernameKey = @"";
static NSString * const cityKey = @"";
static NSString * const regionKey = @"";

@interface User ()

@property (readwrite, nonatomic) BOOL isActive;
@property (readwrite, nonatomic) NSURL *avatarURL;
@property (readwrite, nonatomic) NSString *firstName;
@property (readwrite, nonatomic) NSString *lastName;
@property (readwrite, nonatomic) NSString *email;
@property (readwrite, nonatomic) NSString *username;
@property (readwrite, nonatomic) NSString *password;        // Are we going to store de password??
@property (readwrite, nonatomic) NSString *latitude;
@property (readwrite, nonatomic) NSString *longitude;
@property (readwrite, nonatomic) NSString *city;
@property (readwrite, nonatomic) NSString *region;

@property (readwrite, nonatomic) NSMutableArray *solds;     // array of Products solded by the user
@property (readwrite, nonatomic) NSMutableArray *buys;      // array of Products buyed by the user

@end

@implementation User

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    #pragma mark - TODO: check dic has needed info
    if (dic) {
        User *user = [[User alloc] init];
        user.isActive = dic[activeKey];
        user.avatarURL = dic[avatarKey];
        user.firstName = dic[firstNameKey];
        user.lastName = dic[lastNameKey];
        user.email = dic[emailKey];
        user.username = dic[usernameKey];
        user.city = dic[cityKey];
        user.region = dic[regionKey];
        
        return user;
    }
    
    return nil;
}

#pragma mark - JSONCreator

- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
#pragma mark - TODO: check dic has needed info
    if (obj && [obj isKindOfClass:[self class]]) {
        User *user = (User *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[activeKey] = @(user.isActive);
        mDic[avatarKey] = user.avatarURL;
        mDic[firstNameKey] = user.firstName;
        mDic[lastNameKey] = user.lastName;
        mDic[emailKey] = user.email;
        mDic[usernameKey] = user.username;
        mDic[cityKey] = user.region;
        mDic[regionKey] = user.region;
        
        return [mDic copy];
    }
    
    return nil;
}


@end
