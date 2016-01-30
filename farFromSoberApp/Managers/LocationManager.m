//
//  LocationManager.m
//  farFromSoberApp
//
//  Created by David Regatos on 29/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

#import "UserManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationManager

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
    return self;
}

#pragma mark - Public

- (void)startTrackingPosition {
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)stopTrackingPosition {
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSString *longitude = [NSString stringWithFormat:@"%f", (float)newLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f", (float)newLocation.coordinate.latitude];
    
    [[UserManager sharedInstance] currentUser].latitude = latitude;
    [[UserManager sharedInstance] currentUser].longitude = longitude;
}

@end
