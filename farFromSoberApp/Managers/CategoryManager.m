//
//  CategoryManager.m
//  farFromSoberApp
//
//  Created by Agustín on 06/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "CategoryManager.h"

#import "ProductCategory.h"

@implementation CategoryManager

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static CategoryManager *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

-(NSArray *) loadCategories {
    
    NSMutableArray *categories = [NSMutableArray new];
    
    ProductCategory *cDeportes = [[ProductCategory alloc] init];
    cDeportes.index = 1;
    cDeportes.name = @"Deportes";
    
    ProductCategory *cTecno = [[ProductCategory alloc] init];
    cTecno.index = 2;
    cTecno.name = @"Tecnología";
    
    ProductCategory *cMotor = [[ProductCategory alloc] init];
    cMotor.index = 3;
    cMotor.name = @"Motor";
    
    ProductCategory *cGeneral = [[ProductCategory alloc] init];
    cGeneral.index = 4;
    cGeneral.name = @"General";
    
    [categories addObject:cDeportes];
    [categories addObject:cTecno];
    [categories addObject:cMotor];
    [categories addObject:cGeneral];
    
    return categories;
}

@end
