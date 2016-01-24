//
//  ProfileVC.h
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"
#import <UIKit/UIKit.h>

@interface ProfileVC : BaseVC

@property (nonatomic) NSMutableArray *purchasedProducts;
@property (nonatomic) NSMutableArray *soldProducts;

@property (weak,nonatomic) IBOutlet UILabel *lbName;
@property (weak,nonatomic) IBOutlet UILabel *lbLocation;
@property (weak,nonatomic) IBOutlet UILabel *lbPurchases;
@property (weak,nonatomic) IBOutlet UILabel *lbPurchasesNbr;
@property (weak,nonatomic) IBOutlet UILabel *lbSales;
@property (weak,nonatomic) IBOutlet UILabel *lbSalesNbr;
@property (weak,nonatomic) IBOutlet UISegmentedControl *buttonsControl;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

- (IBAction)logout:(id)sender;


@end
