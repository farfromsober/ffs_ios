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

#import "NewProductViewController.h"
#import "FilterProductsViewController.h"

#import "UserManager.h"
#import "LocationManager.h"

@interface ProductListVC () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,
                             FilterProductsViewControllerDelegate, ProductDetailDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (nonatomic) NSInteger indexCategory;
@property (nonatomic) NSInteger indexDistance;
@property (nonatomic) BOOL searchBarShouldBeginEditing;
@property (nonatomic) BOOL anySearchMade;

@property (strong, nonatomic) LocationManager *locationManager;

@property (strong, nonatomic) UIView *tapDetectorView;

@end

@implementation ProductListVC

#pragma mark - View events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Tracker init
    self.locationManager = [[LocationManager alloc] init];
    
    [self setupNavigationBar];
    [self setupProductCollectionView];
    [self setupRefreshController];
    
    [self initializeData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppStyle hideLogo:NO ToNavBar:self.navigationController.navigationBar];
    [self unregisterForNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AppStyle hideLogo:YES ToNavBar:self.navigationController.navigationBar];
    [self registerForNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startTrackingPosition];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.locationManager stopTrackingPosition];
}

#pragma mark - NSNotification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-keyboardFrameBeginRect.size.height);
    self.tapDetectorView = [[UIView alloc] initWithFrame:rect];
    self.tapDetectorView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tapDetectorView addGestureRecognizer:tap];
    
    [self.view addSubview:self.tapDetectorView];
}

- (void)hideKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.tapDetectorView removeFromSuperview];
    self.tapDetectorView = nil;
}

#pragma mark - Setup View

- (void)setupProductCollectionView {
    self.productsCollectionView.delegate = self;
    self.productsCollectionView.dataSource = self;
    [self.productsCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
}

- (void)setupNavigationBar {
    [AppStyle addProductListNavigationItems:self.navigationItem];
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(favoriteProducts:);
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(filterProducts:);
    
    [self addSearchBar];
}

- (void)addSearchBar {
    self.searchBar = [AppStyle addSearchBarToNavBar:self.navigationController.navigationBar];
    self.searchBar.delegate = self;
    self.searchBarShouldBeginEditing = YES;
    self.anySearchMade = NO;
}

- (void)setupRefreshController {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(initializeData)
                  forControlEvents:UIControlEventValueChanged];
    [self.productsCollectionView addSubview:self.refreshControl];
}

#pragma mark - Data

- (void)initializeData {
    self.indexCategory = -1;
    self.indexDistance = -1;
    
    [self getProductsWithCategory:@"" distance:@"" andKeyword:@""];
}

- (void)resetData {
    if (self.anySearchMade) {
        self.anySearchMade = NO;
        [self initializeData];
    }
}

- (void)getProductsWithCategory:(NSString *)category
                        distance:(NSString *)distance
                         andKeyword:(NSString *)word {
    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Loading products"];
    
    __weak typeof(self) weakSelf = self;
    [self.api fetchProductsWithCategory:category
                               distance:distance
                             andKeyword:word
    success:^(NSURLSessionDataTask *task, NSArray *responseObject) {

        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.products = [NSMutableArray new];
        for (NSDictionary *productDic in responseObject) {
            Product *product = [[Product alloc] initWithJSON:productDic];
            [strongSelf.products addObject:product];
        }
        [strongSelf.productsCollectionView reloadData];
        [strongSelf hideHud];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIAlertController * alert = [self errorAlert:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
        [strongSelf presentViewController:alert animated:YES completion:nil];
        [strongSelf hideHud];
    }];
}

- (void)hideHud {
    [self.hud hide:YES];
    self.hud = nil;
    [self.refreshControl endRefreshing];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText  isEqual: @""]) {
        // user tapped the 'clear' button
        self.searchBarShouldBeginEditing = NO;
        [searchBar resignFirstResponder];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    BOOL boolToReturn = self.searchBarShouldBeginEditing;
    self.searchBarShouldBeginEditing = YES;
    if (!boolToReturn) {
        [self resetData];
    }
    return boolToReturn;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@",searchBar.text);
    [searchBar resignFirstResponder];
    self.anySearchMade = YES;
    NSString *searchWord = [[searchBar.text componentsSeparatedByString:@" "] objectAtIndex:0];
    
    [self getProductsWithCategory:@"" distance:@"" andKeyword:searchWord];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.products count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"productCell";
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                forIndexPath:indexPath];
    
    Product *cellData = [self.products objectAtIndex:indexPath.row];
    [cell setupCell:cellData];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    
    ProductDetailViewController *pdVC = [[ProductDetailViewController alloc] initWithProduct:product];
    pdVC.delegate = self;
    [self.navigationController pushViewController:pdVC animated:YES];
}

// Adjust CollectionView Cell Size
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth = (self.view.bounds.size.width-20-20-15)/2;
    return CGSizeMake(cellWidth, cellWidth*1.33);
}

#pragma mark - IBActions

- (IBAction)favoriteProducts:(id)sender { }

- (IBAction)filterProducts:(id)sender {
    
    NSInteger indexC = (self.indexCategory >= 0 && self.indexCategory) ? self.indexCategory : -1;
    NSInteger indexD = (self.indexDistance >= 0 && self.indexDistance) ? self.indexDistance : -1;
    
    FilterProductsViewController *filVC = [[FilterProductsViewController alloc] initWithIndexCategorySelected:indexC
                                                                                             andIndexDistance:indexD];
    filVC.myDelegate = self;
    [self presentViewController:filVC animated:YES completion:nil];
}

- (IBAction)newProductButtonPressed:(UIButton *)sender {
    NewProductViewController *npVC = [[NewProductViewController alloc] initWithProduct:[Product new]];
    [self presentViewController:npVC animated:YES completion:nil];
}

#pragma mark - FilterViewControllerDelegate

- (void)filterProductsViewControllerDismissed:(NSString *)indexCategory indexDistance:(NSString *)indexDistance {
    
    self.indexCategory = [indexCategory integerValue];
    self.indexDistance = [indexDistance integerValue];
    
    [self getProductsWithCategory:indexCategory distance:indexDistance andKeyword:@""];
}

#pragma mark - ProductDetailDelegate

- (void)productDetailProductBougth:(Product *)product {
    [self.products removeObject:product];
    [self.productsCollectionView reloadData];
}

@end
