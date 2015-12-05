//
//  UserManager.m
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "UserManager.h"
#import "AppConstants.h"

@interface UserManager ()

@property (readwrite, nonatomic) User *currentUser;

@end

@implementation UserManager

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static UserManager *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (User *)currentUser {
    if (!_currentUser) {
        _currentUser = [self loadUser];
    }
    return _currentUser;
}

#pragma mark - Persistence

- (User *)loadUser {
    NSData *decodedData = [NSData dataWithContentsOfFile:[self filePath]];
    if (decodedData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
    }
    
    return nil;
}

- (BOOL)createUser:(User *)user {
    
    if (self.currentUser) {
        [self resetUser];
    }
    
    // Save
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:user];
    if ([encodedData writeToFile:[self filePath] atomically:YES]) {
        // Save works!!
        self.currentUser = user;
        return YES;
    }
    
    return NO;
}

- (BOOL)updateUser:(User *)user {
    if ([user isEqual:self.currentUser]) {  // Equal means = userId
        return [self createUser:user];
    }
    
    return NO;
}

- (void)resetUser {
    // TODO - remove stored User
}

#pragma mark - Utils

- (NSString *)filePath {
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:[AppConstants userStoragePath]];
    }
    return filePath;
}

@end
