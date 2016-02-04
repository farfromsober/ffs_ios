//
//  NewProductViewController.h
//  farFromSoberApp
//
//  Created by Agustín on 05/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@class Product;

@interface NewProductViewController : BaseVC <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDescriptionLength;
@property (weak, nonatomic) IBOutlet UITextView *lbDescription;
@property (weak, nonatomic) IBOutlet UITextField *lbCategory;
@property (weak, nonatomic) IBOutlet UITextField *lbPrice;
@property (weak, nonatomic) IBOutlet UITextField *lbMoney;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct1;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct2;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct3;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct4;
@property (weak, nonatomic) IBOutlet UIButton *btSellIt;
@property (weak, nonatomic) IBOutlet UIButton *btCancel;

- (IBAction)btSellIt:(id)sender;
- (IBAction)btAction:(id)sender;

-(instancetype) initWithProduct: (Product *) produt;
@end
