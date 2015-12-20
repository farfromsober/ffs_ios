//
//  ProductListVC.m
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProductListVC.h"
#import "Product.h"

#import "ProductCollectionViewCell.h"
#import "ProductDetailViewController.h"
#import "NewProductViewController.h"
#import "FilterProductsViewController.h"
#import "MBProgressHUD.h"
#import "AppStyle.h"

#import "AlertUtil.h"

@interface ProductListVC () <UISearchResultsUpdating>

@property (nonatomic) NSMutableArray *products;
@property (nonatomic) NSInteger indexCategory;
@property (nonatomic) NSInteger indexDistance;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NavigationBar
    //[AppStyle hideLogo:YES ToNavBar:self.navigationController.navigationBar];
    [AppStyle addSearchBarToNavBar:self.navigationController.navigationBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorites"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(favoriteProducts)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filter"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(filterProducts)];
    
    
    [self initializeData];
    
    self.cvProductsCollection.delegate = self;
    self.cvProductsCollection.dataSource = self;
    [self.cvProductsCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNewProduct:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.imgNewProduct addGestureRecognizer:tap];
    
    
    // Inicializamos el refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(initializeData)
                  forControlEvents:UIControlEventValueChanged];
    [self.cvProductsCollection addSubview:self.refreshControl];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //[AppStyle hideLogo:NO ToNavBar:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[AppStyle hideLogo:YES ToNavBar:self.navigationController.navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeData {
    self.indexCategory = -1;
    self.indexDistance = -1;
    
    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Loading products"];
    
    [self.api productsViaCategory:@"" andDistance:@"" andWord:@"" Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        self.products = [NSMutableArray new];
        
        for (NSDictionary *productDic in responseObject) {
            Product *product = [[Product alloc] initWithJSON:productDic];
            [self.products addObject:product];
        }
        [self.cvProductsCollection reloadData];
        
        [self.hud hide:YES];
        self.hud = nil;
        [self.refreshControl endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Error: %@", error);
        [self.hud hide:YES];
        self.hud = nil;
        [self.refreshControl endRefreshing];

    }];
  
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.products count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"productCell";
    
    ProductCollectionViewCell *cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Product *cellData = [self.products objectAtIndex:indexPath.row];
    
    cell.lbPrice.text = [NSString stringWithFormat:@"%@€",[cellData price]];
    cell.lbTitle.text = [cellData name];
    
    [cell setImageWithURL:[[cellData images] firstObject]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    
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

#pragma mark - Navigation buttons action

-(void) favoriteProducts {
    
}

-(void) filterProducts {
    
    NSInteger indexC = self.indexCategory > -1 ? self.indexCategory : -1;
    NSInteger indexD = self.indexDistance > -1 ? self.indexDistance : -1;
    
    FilterProductsViewController *filVC = [[FilterProductsViewController alloc] initWithIndexCategorySelected:indexC andIndexDistance:indexD];
    filVC.myDelegate = self;
    [self presentViewController:filVC animated:YES completion:^{
        
    }];
}

#pragma mark - FilterViewController delegate
-(void)filterProductsViewControllerDismissed:(NSString *)indexCategory indexDistance:(NSString *)indexDistance{
    
    self.indexCategory = [indexCategory integerValue] - 1;
    self.indexDistance = [indexDistance integerValue] - 1;
    
    [self.api productsViaCategory:indexCategory andDistance:indexDistance andWord:@"" Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        self.products = [NSMutableArray new];
        
        for (NSDictionary *productDic in responseObject) {
            Product *product = [[Product alloc] initWithJSON:productDic];
            [self.products addObject:product];
        }
        [self.cvProductsCollection reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Error: %@", error);
        
    }];
}

#pragma mark - Tap New Product
-(void) tapNewProduct:(UIGestureRecognizer *)gestureRecognizer {
    
    Product *product = [[Product alloc] init];
    
    NewProductViewController *npVC = [[NewProductViewController alloc] initWithProduct:product];
    [self presentViewController:npVC animated:YES completion:^{
        
    }];
}

@end
