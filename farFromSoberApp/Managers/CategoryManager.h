//
//  CategoryManager.h
//  farFromSoberApp
//
//  Created by Agustín on 06/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryManager : NSObject

+ (instancetype)sharedInstance;

@property (copy, nonatomic) NSArray *categories;

-(NSArray *) loadCategories;
@end
