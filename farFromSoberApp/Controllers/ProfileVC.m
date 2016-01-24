//
//  ProfileVC.m
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProfileVC.h"

#import "UserManager.h"
#import "AppNavigation.h"
#import "MBProgressHUD.h"
#import "AppStyle.h"
#import "Product.h"
#import "AlertUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductCollectionViewCell.h"
#import "ProductDetailViewController.h"


static NSString * const sale = @"sale";
static NSString * const sold = @"sold";
static NSString * const purchased = @"purchased";

@interface ProfileVC ()

@property (strong, nonatomic) MBProgressHUD *hud;
@property (copy, nonatomic) NSString *typeList;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [AppStyle styleProfileViewController:self];
    [self initializeData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    UserManager *manager = [UserManager sharedInstance];
    if ([manager resetUser]) {
        [AppNavigation onLogoutFromViewController:self];
    }
}

-(void) initializeData {
    
    UserManager *manager = [UserManager sharedInstance];
    User *user = [manager currentUser];
    self.typeList = sale;
    
    [self getProductsWithUser];
    
    self.lbName.text = [NSString stringWithFormat:@"%@|%@|%@",[user firstName],@" ",[user lastName]];
    
    self.lbLocation.text = [user city];
    self.lbSalesNbr.text = [[user sales] stringValue];

    // NSUInteger purchases = [self.purchasedProducts count];
    
    //self.lbPurchasesNbr.text = [NSString stringWithFormat:@"%@",  @(purchases)];
    
    [self.imgAvatar sd_setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    
    self.cvProductsCollection.delegate = self;
    self.cvProductsCollection.dataSource = self;
    [self.cvProductsCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
    
}

- (void) getProductsWithUser {
    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Loading products"];
    UserManager *manager = [UserManager sharedInstance];
    User *user = [manager currentUser];
    BOOL selling;
    
    if (self.typeList == sale) {
        selling = true;
    } else {
        selling = false;
    }
    
    [self.api productsForUser: user.username selling: selling Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        self.productList = [NSMutableArray new];
        
        for (NSDictionary *productDic in responseObject) {
            Product *product = [[Product alloc] initWithJSON:productDic];
            [self.productList addObject:product];
        }
        [self.cvProductsCollection reloadData];
        
        [self.hud hide:YES];
        self.hud = nil;
   //     [self.refreshControl endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Error: %@", error);
        [self.hud hide:YES];
        self.hud = nil;
        //[self.refreshControl endRefreshing];
    }];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"productCell";
    
    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Product *cellData = [self.productList objectAtIndex:indexPath.row];
    
    cell.lbPrice.text = [NSString stringWithFormat:@"%@€",[cellData price]];
    cell.lbTitle.text = [cellData name];
    
    [cell setImageWithURL:[[cellData images] firstObject]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    ProductDetailViewController *pdVC = [[ProductDetailViewController alloc] initWithProduct: product];
    [self.navigationController pushViewController:pdVC animated:YES];
}

// Adjust CollectionView Cell Size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth = (self.view.bounds.size.width-20-20-15)/2;
    return CGSizeMake(cellWidth, cellWidth*1.33);
}

@end
