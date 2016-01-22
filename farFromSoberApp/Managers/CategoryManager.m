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
    
    ProductCategory *cMac = [[ProductCategory alloc] init];
    cMac.index = 0;
    cMac.name = @"Mac";
    
    ProductCategory *ciPad = [[ProductCategory alloc] init];
    ciPad.index = 1;
    ciPad.name = @"iPad";
    
    ProductCategory *ciPhone = [[ProductCategory alloc] init];
    ciPhone.index = 2;
    ciPhone.name = @"iPhone";
    
    ProductCategory *cWatch = [[ProductCategory alloc] init];
    cWatch.index = 3;
    cWatch.name = @"Watch";
    
    ProductCategory *cTV = [[ProductCategory alloc] init];
    cTV.index = 4;
    cTV.name = @"TV";
    
    ProductCategory *cMusic = [[ProductCategory alloc] init];
    cMusic.index = 5;
    cMusic.name = @"Music";
    
    [categories addObject:cMac];
    [categories addObject:ciPad];
    [categories addObject:ciPhone];
    [categories addObject:cWatch];
    [categories addObject:cTV];
    [categories addObject:cMusic];
    
    return categories;
}

@end
