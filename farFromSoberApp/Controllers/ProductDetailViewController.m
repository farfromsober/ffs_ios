//
//  ProductDetailViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 01/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProductDetailViewController.h"

#import "Product.h"
#import "User.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ProductDetailViewController ()

@property (nonatomic, strong) Product *product;
@end

@implementation ProductDetailViewController

#pragma mark - Init

-(instancetype) initWithProduct: (Product *) produt {
    
    self = [super init];
    if (self) {
        _product = produt;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize Data

-(void) initializeData {
    
    self.title = @"Product";
    
    [self.imgProduct sd_setImageWithURL:self.product.images[0]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.imgProfile sd_setImageWithURL:self.product.seller.avatarURL
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.lbDateProfile.text = [NSString stringWithFormat:@"%@",self.product.published];
    self.lbDescriptionProduct.text = self.product.description;
    self.lbNameProfile.text = self.product.seller.username;
    self.lbNumberPhotos.text = [NSString stringWithFormat:@"%lu",[self.product.images count]];
    self.lbPrice.text = self.product.price;
    //self.lbState.text = self.product.s
    self.lbTitleProduct.text = self.product.name;
}

@end
