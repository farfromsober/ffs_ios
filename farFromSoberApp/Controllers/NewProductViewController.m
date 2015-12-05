//
//  NewProductViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 05/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NewProductViewController.h"

#import "Product.h"
#import "ProductCategory.h"

#import <SDWebImage/UIImageView+WebCache.h>

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
    
    self.lbTitle.delegate = self;
    self.lbCategory.delegate = self;
    self.lbPrice.delegate = self;
    
    [self.imgProduct1 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    [self.imgProduct2 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    [self.imgProduct3 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    [self.imgProduct4 setImage:[UIImage imageNamed:@"photo_placeholder"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons Action

- (IBAction)btSellIt:(id)sender {
    
    self.product.name = self.lbTitle.text;
    self.product.detail = self.lbDescription.text;
    
    //ProductCategory *category = [[ProductCategory alloc] init];
    //category.name
    //self.product.category
    
    self.product.price = self.lbPrice.text;
    
    
    
}

- (IBAction)btAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Keyboar hide

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.lbTitle isFirstResponder] && [touch view] != self.lbTitle) {
        [self.lbTitle resignFirstResponder];
    } else if ([self.lbCategory isFirstResponder] && [touch view] != self.lbCategory) {
        [self.lbCategory resignFirstResponder];
    } else if ([self.lbPrice isFirstResponder] && [touch view] != self.lbPrice) {
        [self.lbPrice resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextView delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0) {
        [self.lbDescription becomeFirstResponder];
    } else if (textField.tag == 1) {
        [self.lbCategory becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.lbPrice becomeFirstResponder];
    } else {
        [self btSellIt:nil];
    }
    
    return YES;
}
@end
