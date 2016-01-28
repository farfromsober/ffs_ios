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
#import "MBProgressHUD.h"
#import "AppStyle.h"
#import "AlertUtil.h"
#import "UserManager.h"

@interface ProductListVC () <UISearchBarDelegate>

@property (nonatomic) NSInteger indexCategory;
@property (nonatomic) NSInteger indexDistance;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic) BOOL searchBarShouldBeginEditing;
@property (nonatomic) BOOL anySearchMade;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

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
    
    // Declaramos delegado de la searchBar
    self.searchBar = (UISearchBar *)self.navigationController.navigationBar.topItem.titleView;
    self.searchBar.delegate = self;
    self.searchBarShouldBeginEditing = YES;
    self.anySearchMade = NO;
    
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppStyle hideLogo:NO ToNavBar:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AppStyle hideLogo:YES ToNavBar:self.navigationController.navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeData {
    self.indexCategory = -1;
    self.indexDistance = -1;
    
    [self getProductsWithCategory:@"" Distance:@"" AndWord:@""];
}

- (void) resetData {
    if (self.anySearchMade) {
        self.anySearchMade = NO;
        [self initializeData];
    }
}

- (void) getProductsWithCategory: (NSString *) category
                        Distance: (NSString *) distance
                         AndWord: (NSString *) word {
    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Loading products"];
    
    [self.api productsViaCategory:category andDistance:distance andWord:word Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
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

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@",searchBar.text);
    [searchBar resignFirstResponder];
    self.anySearchMade = YES;
    NSString *searchWord = [[searchBar.text componentsSeparatedByString:@" "] objectAtIndex:0];
    
    [self getProductsWithCategory:@"" Distance:@"" AndWord:searchWord];
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

#pragma mark - Navigation buttons action

-(void) favoriteProducts {
    
}

-(void) filterProducts {
    
    NSInteger indexC = self.indexCategory >= 0 ? self.indexCategory : -1;
    NSInteger indexD = self.indexDistance >= 0 ? self.indexDistance : -1;
    
    FilterProductsViewController *filVC = [[FilterProductsViewController alloc] initWithIndexCategorySelected:indexC andIndexDistance:indexD];
    filVC.myDelegate = self;
    [self presentViewController:filVC animated:YES completion:^{
        
    }];
}

#pragma mark - FilterViewController delegate
- (void)filterProductsViewControllerDismissed:(NSString *)indexCategory indexDistance:(NSString *)indexDistance{
    
    self.indexCategory = [indexCategory integerValue];
    self.indexDistance = [indexDistance integerValue];
    
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
- (void)tapNewProduct:(UIGestureRecognizer *)gestureRecognizer {
    
    Product *product = [[Product alloc] init];
    
    NewProductViewController *npVC = [[NewProductViewController alloc] initWithProduct:product];
    [self presentViewController:npVC animated:YES completion:^{
        
    }];
}

#pragma mark - Location
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.longitude = [NSString stringWithFormat:@"%f", (float)newLocation.coordinate.longitude];
    self.latitude = [NSString stringWithFormat:@"%f", (float)newLocation.coordinate.latitude];
    
    [[UserManager sharedInstance] currentUser].latitude = self.latitude;
    [[UserManager sharedInstance] currentUser].longitude = self.longitude;
}

#pragma mark - ProductDetailDelegate
- (void)productDetailProductBougth:(Product *)product {
    [self.products removeObject:product];
    [self.cvProductsCollection reloadData];
}

@end
