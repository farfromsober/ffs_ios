//
//  ProductDetailViewController.h
//  farFromSoberApp
//
//  Created by Agustín on 01/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseVC.h"

@class Product;

@interface ProductDetailViewController : BaseVC

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lbNumberPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lbState;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbNameProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbDateProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleProduct;
@property (weak, nonatomic) IBOutlet UITextView *lbDescriptionProduct;
@property (weak, nonatomic) IBOutlet UILabel *lbLocation;
@property (weak, nonatomic) IBOutlet IBOutlet MKMapView *mvMap;
@property (weak, nonatomic) IBOutlet UIButton *btBuyProduct;
-(instancetype) initWithProduct: (Product *) produt;

@end
