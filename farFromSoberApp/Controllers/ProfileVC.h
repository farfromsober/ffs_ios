//
//  ProfileVC.h
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"
#import <UIKit/UIKit.h>

@interface ProfileVC : BaseVC <UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic) NSMutableArray *productList;


@property (weak,nonatomic) IBOutlet UILabel *lbName;
@property (weak,nonatomic) IBOutlet UILabel *lbLocation;
@property (weak,nonatomic) IBOutlet UILabel *lbPurchases;
@property (weak,nonatomic) IBOutlet UILabel *lbPurchasesNbr;
@property (weak,nonatomic) IBOutlet UILabel *lbSales;
@property (weak,nonatomic) IBOutlet UILabel *lbSalesNbr;
@property (weak,nonatomic) IBOutlet UISegmentedControl *buttonsControl;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UICollectionView *cvProductsCollection;
@property (weak, nonatomic) IBOutlet UIView *viewProducts;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewProducts;


- (IBAction)logout:(id)sender;


@end
