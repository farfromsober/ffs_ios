//
//  ProductListVC.h
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"
#import "FilterProductsViewController.h"

@interface ProductListVC : BaseVC <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, FilterProductsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cvProductsCollection;
@property (weak, nonatomic) IBOutlet UIImageView *imgNewProduct;
@end
