//
//  AppConstants.h
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface AppConstants : NSObject

+ (NSString *)userStoragePath;
+ (float) defaultLatitude;
+ (float) defaultLongitude;
+ (CLLocationCoordinate2D) defaultLocation;
+ (int) maxPermitedChars;

@end
