//
//  UserDetailVC.h
//  farFromSoberApp
//
//  Created by Joan on 23/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//
#import "BaseVC.h"
#import <UIKit/UIKit.h>

@class User;

@interface UserDetailVC : BaseVC<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *cvProductsCollection;

- (instancetype)initWithUser:(User *)user;

    
@end
