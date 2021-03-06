//
//  ProductoCollectionViewCell.h
//  farFromSoberApp
//
//  Created by Agustín on 29/11/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

- (void)setupCell:(Product *)data;

@end
