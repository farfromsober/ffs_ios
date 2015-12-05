//
//  NewProductViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 05/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NewProductViewController.h"

#import "Product.h"

@interface NewProductViewController ()

@property (nonatomic, strong) Product *product;

@end

@implementation NewProductViewController

#pragma mark - Inits
-(instancetype) initWithProduct: (Product *) produt {
    
    self = [super init];
    if (self) {
        _product = produt;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btSellIt:(id)sender {
}

- (IBAction)btAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
