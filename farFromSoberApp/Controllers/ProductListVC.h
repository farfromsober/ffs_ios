//
//  ProductListVC.h
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"
#import "FilterProductsViewController.h"
#import "ProductDetailViewController.h"


@interface ProductListVC : BaseVC 

@property (weak, nonatomic) IBOutlet UICollectionView *productsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addProductButton;

@property (nonatomic) NSMutableArray *products;

@end
