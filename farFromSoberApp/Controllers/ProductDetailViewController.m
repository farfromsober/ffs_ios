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
#import "AppStyle.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

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
    
    [AppStyle styleProductDetailViewController:self];
    
    [self initializeData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize Data

-(void) initializeData {
    
    self.title = @"Product";
    
    [self.imgProduct sd_setImageWithURL:[self.product.images firstObject]
                       placeholderImage:[UIImage imageNamed:@"photo_placeholder_frame"]];
    [self.imgProfile sd_setImageWithURL:self.product.seller.avatarURL
                       placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height /2;
    self.imgProfile.layer.masksToBounds = YES;
    self.imgProfile.layer.borderWidth = 0;
    
    self.lbDateProfile.text = self.product.dateFormatted;
    self.lbDescriptionProduct.text = self.product.detail;
    self.lbNameProfile.text = self.product.seller.username;
    
    NSString *photos = [self.product.images count] <= 0 ? [NSString stringWithFormat:@"%lu Photo",(unsigned long)[self.product.images count] ] : [NSString stringWithFormat:@"%lu Photos",(unsigned long)[self.product.images count]];
    self.lbNumberPhotos.text = photos;
    self.lbNumberPhotos.layer.backgroundColor = [[UIColor colorWithRed:252/255.0f green:183/255.0f blue:151/255.0f alpha:1.0f] CGColor];
    self.lbNumberPhotos.layer.cornerRadius = 12;
    
    self.lbPrice.text = [NSString stringWithFormat:@"%@€",self.product.price];
    
    self.lbState.text = self.product.isSelling ? @"For sell" : @"Sold";
    self.lbState.layer.backgroundColor = [[UIColor colorWithRed:252/255.0f green:183/255.0f blue:151/255.0f alpha:1.0f] CGColor];
    self.lbState.layer.cornerRadius = 12;
    
    self.lbTitleProduct.text = self.product.name;
    
    // Ponemos la localización del producto y le añadimos un pin
    MKCoordinateRegion region;
    region.center = self.product.seller.location;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    [annotation setCoordinate:self.product.seller.location];
    [annotation setTitle:self.product.seller.username];
    [self.mvMap setRegion:region animated:YES];
    [self.mvMap addAnnotation:annotation];
}

@end
