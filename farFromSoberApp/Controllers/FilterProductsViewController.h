//
//  FilterProductsViewController.h
//  farFromSoberApp
//
//  Created by Agustín on 06/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterProductsViewControllerDelegate <NSObject>
-(void) filterProductsViewControllerDismissed:(NSString *)indexCategory indexDistance:(NSString *)indexDistance;
@end

@interface FilterProductsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) id<FilterProductsViewControllerDelegate> myDelegate;

@property (weak, nonatomic) IBOutlet UIButton *btCancel;
@property (weak, nonatomic) IBOutlet UIButton *btSave;
@property (weak, nonatomic) IBOutlet UITableView *tvCategories;
@property (weak, nonatomic) IBOutlet UITableView *tvDistance;

@property (weak, nonatomic) IBOutlet UILabel *lbFilter;
@property (strong, nonatomic) UILabel *lbCategories;
@property (strong, nonatomic) UILabel *lbDistance;
@property (strong, nonatomic) UIView *categoriesHeaderView;
@property (strong, nonatomic) UIView *distanceHeaderView;

- (IBAction)btCancel:(id)sender;
- (IBAction)btSave:(id)sender;

-(instancetype) initWithIndexCategorySelected: (NSInteger) indexCategory andIndexDistance: (NSInteger) indexDistance;
@end
