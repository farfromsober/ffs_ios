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
@import CoreLocation;

@interface User : NSObject <JSONParser, JSONCreator>

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *sales;

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;
@property (nonatomic) CLLocationCoordinate2D location;

@property (strong, nonatomic) NSURL *avatarURL;

@end
