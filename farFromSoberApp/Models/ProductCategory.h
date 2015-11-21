//
//  Type.h
//  farFromSoberApp
//
//  Created by David Regatos on 14/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import "JSONCreator.h"

@interface ProductCategory : NSObject <JSONParser, JSONCreator>

@property (nonatomic) NSInteger index;
@property (copy, nonatomic) NSString *name;

@end
