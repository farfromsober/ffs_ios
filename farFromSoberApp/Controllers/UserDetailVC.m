//
//  UserDetailVC.m
//  farFromSoberApp
//
//  Created by Joan on 23/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import "UserDetailVC.h"
#import "ProductCollectionViewCell.h"
#import "Product.h"
#import "MBProgressHUD.h"
#import "AppStyle.h"
#import "AppNavigation.h"
#import "UserManager.h"
#import "User.h"


@interface UserDetailVC ()
@property (nonatomic) NSMutableArray *products;
@property (nonatomic) User *user;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) UserDataProductsListType selectedType;



@end

@implementation UserDetailVC

- (instancetype)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        _user = user;
        self.selectedType = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];  
    self.productsCollectionView.delegate = self;
    self.productsCollectionView.dataSource = self;
    [self.productsCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
    [self.productsCollectionView registerClass:[UserDataCollectionViewCell class] forCellWithReuseIdentifier:@"userCell"];
    [self.productsCollectionView registerNib:[UINib nibWithNibName:@"UserDataCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"userCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AppStyle styleNavBar:self.navigationController.navigationBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getProductsType {
    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Loading products"];
    if (self.selectedType == 0 || self.selectedType == 1) {
        [self.api productsForUser:self.user.username selling:self.selectedType == UserDataProductsListTypeSelling
                          Success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
                              self.products = [NSMutableArray new];
                              
                              for (NSDictionary *productDic in responseObject) {
                                  Product *product = [[Product alloc] initWithJSON:productDic];
                                  self.user = product.seller;
                                  [self.products addObject:product];
                              }
                              [self.productsCollectionView reloadData];
                              
                              [self.hud hide:YES];
                              self.hud = nil;
                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                              
                          }];
    } else {
        [self.api productsBoughtSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            self.products = [NSMutableArray new];
            
            for (NSDictionary *productDic in responseObject) {
                Product *product = [[Product alloc] initWithJSON:productDic];                
                [self.products addObject:product];
            }
            [self.productsCollectionView reloadData];
            
            [self.hud hide:YES];
            self.hud = nil;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

    }
}

- (void)setSelectedType:(UserDataProductsListType)selectedType {
    _selectedType = selectedType;
    [self getProductsType];
}


#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else
        return self.products.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"productCell";
    static NSString *cellIdentifierHeader = @"userCell";
    if (indexPath.section == 0) {
        UserDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierHeader forIndexPath:indexPath];
        cell.user = self.user;
        [cell.segmentedControl setSelectedSegmentIndex:self.selectedType];
        cell.delegate = self;
        return cell;
    } else {
        ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        Product *cellData = [self.products objectAtIndex:indexPath.row];
        
        [cell setupCell:cellData];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        Product *product = [self.products objectAtIndex:indexPath.row];
        
        ProductDetailViewController *pdVC = [[ProductDetailViewController alloc] initWithProduct:product];
        pdVC.delegate = self;
        [self.navigationController pushViewController:pdVC animated:YES];
    }
}

// Adjust CollectionView Cell Size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat cellWidth = self.view.bounds.size.width;
        CGFloat cellHeigth = 170;
        return CGSizeMake(cellWidth, cellHeigth);
    } else {
        CGFloat cellWidth = (self.view.bounds.size.width-20-20-15)/2;
        return CGSizeMake(cellWidth, cellWidth*1.33);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0)
        return UIEdgeInsetsMake(0, 0, 0, 0);
    else
        return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark - UserDataCollectionViewCellDelegate
- (void)userDataCollectionViewCellSelectedOption:(UserDataProductsListType)type {
    self.selectedType = type;
}

- (void)userDataCollectionViewCellSelectedLogout {
    UserManager *manager = [UserManager sharedInstance];
    if ([manager resetUser]) {
        [AppNavigation onLogoutFromViewController:self];
    }
}

#pragma mark - ProductDetailDelegate
- (void)productDetailProductBougth:(Product *)product {
    [self.products removeObject:product];
    self.user.sales = @([self.user.sales intValue]+1);
    [self.productsCollectionView reloadData];
}


@end
