//
//  User.m
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "User.h"
#import "NSDictionary+Secure.h"
#import "NSString+Validator.h"
#import "AppConstants.h"

static NSString * const userKey = @"user";

static NSString * const salesKey = @"sales";
static NSString * const idKey = @"id";
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

#pragma mark - Storing & retriving

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.sales forKey:salesKey];
    [encoder encodeObject:self.userId forKey:idKey];
    [encoder encodeObject:self.firstName forKey:firstNameKey];
    [encoder encodeObject:self.lastName forKey:lastNameKey];
    [encoder encodeObject:self.email forKey:emailKey];
    [encoder encodeObject:self.username forKey:usernameKey];
    [encoder encodeObject:self.city forKey:cityKey];
    [encoder encodeObject:self.state forKey:stateKey];
    [encoder encodeObject:self.latitude forKey:latitudeKey];
    [encoder encodeObject:self.longitude forKey:longitudeKey];
    [encoder encodeObject:self.avatarURL forKey:avatarKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.sales = [decoder decodeObjectForKey:salesKey];
        self.userId = [decoder decodeObjectForKey:idKey];
        self.firstName = [decoder decodeObjectForKey:firstNameKey];
        self.lastName = [decoder decodeObjectForKey:lastNameKey];
        self.email = [decoder decodeObjectForKey:emailKey];
        self.username = [decoder decodeObjectForKey:usernameKey];
        self.city = [decoder decodeObjectForKey:cityKey];
        self.state = [decoder decodeObjectForKey:stateKey];
        self.latitude = [decoder decodeObjectForKey:latitudeKey];
        self.longitude = [decoder decodeObjectForKey:longitudeKey];
        self.avatarURL = [decoder decodeObjectForKey:avatarKey];
    }
    return self;
}

#pragma mark - JSONParser

- (id<JSONParser>)initWithJSON:(NSDictionary *)dic {
    // Doble comprobación...
    if (dic && [[self class] hasNeededInformation:dic]) {
        User *user = [[User alloc] init];
        
        NSDictionary *userDic = dic[userKey];
        user.userId = dic[idKey] ? dic[idKey] : @(0);
        user.firstName = userDic[firstNameKey] ? userDic[firstNameKey] : @"";
        user.lastName = userDic[lastNameKey] ? userDic[lastNameKey] : @"";
        user.email = userDic[emailKey] ? userDic[emailKey] : @"";
        user.username = userDic[usernameKey] ? userDic[usernameKey] : @"";
        
        user.avatarURL = dic[avatarKey] ? [NSURL URLWithString:dic[avatarKey]] : [NSURL URLWithString:@""];
        user.latitude = dic[latitudeKey] ? dic[latitudeKey] : @"";
        user.longitude = dic[longitudeKey] ? dic[longitudeKey] : @"";
        user.city = dic[cityKey] ? dic[cityKey] : @"";
        user.state = dic[stateKey] ? dic[stateKey] : @"";
        user.sales = dic[salesKey] ? dic[salesKey] : @(0);
        
        if ([user.latitude compare:@""] == 0 || [user.longitude compare:@""] == 0){
            user.location = [AppConstants defaultLocation];
        } else {
            user.location = CLLocationCoordinate2DMake([user.latitude floatValue], [user.longitude floatValue]);
        }

        return user;
    }
    
    return nil;
}

#pragma mark - JSONCreator

- (NSDictionary *)objectToJSON:(id<JSONCreator>)obj {
    if (obj && [obj isKindOfClass:[self class]]) {
        User *user = (User *)obj;
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic[salesKey] = user.sales ? user.sales : @(0);
        mDic[idKey] = user.userId ? user.userId : @"";
        mDic[userKey] = [NSMutableDictionary new];
        mDic[userKey][firstNameKey] = user.firstName ? user.firstName : @"";
        mDic[userKey][lastNameKey] = user.lastName ? user.lastName : @"";
        mDic[userKey][emailKey] = user.email ? user.email : @"";
        mDic[userKey][usernameKey] = user.username ? user.username : @"";
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
    
    NSDictionary *userDic = [dic objectForKey:userKey];
    
    if (!userDic) {
        return NO;
    } else if (!dic[idKey]) {
         return NO;
     } else if ([NSString isEmpty:userDic[emailKey]]) {
         return NO;
     } else if ([NSString isEmpty:userDic[usernameKey]]) {
         return NO;
     }
    
    return YES;
}

#pragma mark - Overriden

- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[self class]]) {
        return [self.userId isEqualToNumber:((User *)other).userId];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.userId integerValue];
}



@end
