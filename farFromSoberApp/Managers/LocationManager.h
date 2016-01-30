//
//  LocationManager.h
//  farFromSoberApp
//
//  Created by David Regatos on 29/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

- (void)startTrackingPosition;
- (void)stopTrackingPosition;

@end
