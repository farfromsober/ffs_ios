//
//  UserDetailVC.h
//  farFromSoberApp
//
//  Created by Joan on 23/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//
#import "BaseVC.h"
#import <UIKit/UIKit.h>
#import "UserDataCollectionViewCell.h"
#import "ProductDetailViewController.h"



@class User;

@interface UserDetailVC : BaseVC<UICollectionViewDelegate, UICollectionViewDataSource, UserDataCollectionViewCellDelegate, ProductDetailDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cvProductsCollection;

- (instancetype)initWithUser:(User *)user;

    
@end
