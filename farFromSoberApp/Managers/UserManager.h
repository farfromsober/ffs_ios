//
//  UserManager.h
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

+ (instancetype)sharedInstance;

@property (readonly, nonatomic) User *currentUser;

- (User *)currentUser;
- (BOOL)createUser:(User *)user;
- (BOOL)updateUser:(User *)user;
- (BOOL)resetUser;

@end
