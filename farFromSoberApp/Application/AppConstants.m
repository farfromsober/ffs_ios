//
//  AppConstants.m
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "AppConstants.h"

@implementation AppConstants


+ (NSString *)userStoragePath {
    return @"user_profile";
}

+ (float) defaultLatitude{
    return 40.4167754f;
}

+ (float) defaultLongitude{
    return -3.7037902f;
}

+ (CLLocationCoordinate2D) defaultLocation{
    return CLLocationCoordinate2DMake([self.class defaultLatitude], [self.class defaultLongitude]);
}

@end
