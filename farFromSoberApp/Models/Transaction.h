//
//  Transaction.h
//  farFromSoberApp
//
//  Created by David Regatos on 17/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import "JSONCreator.h"

@class Product;
@class User;

@interface Transaction : NSObject <JSONCreator, JSONParser>

@property (copy, nonatomic) NSString *transactionId;
@property (strong, nonatomic) Product *product;         // seller is inside
@property (strong, nonatomic) User *buyer;
@property (strong, nonatomic) NSDate *date;

@end
