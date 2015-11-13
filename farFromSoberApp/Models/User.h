//
//  User.h
//  farFromSoberApp
//
//  Created by David Regatos on 13/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import "JSONCreator.h"

@interface User : NSObject <JSONParser, JSONCreator>

@property (readonly, nonatomic) BOOL isActive;
@property (readonly, nonatomic) NSURL *avatarURL;
@property (readonly, nonatomic) NSString *firstName;
@property (readonly, nonatomic) NSString *lastName;
@property (readonly, nonatomic) NSString *email;
@property (readonly, nonatomic) NSString *username;
@property (readonly, nonatomic) NSString *password;     // Are we going to store de password??
@property (readonly, nonatomic) NSString *city;
@property (readonly, nonatomic) NSString *region;

@property (readonly, nonatomic) NSArray *solds;         // array of Products solded by the user
@property (readonly, nonatomic) NSArray *buys;          // array of Products buyed by the user

@end
