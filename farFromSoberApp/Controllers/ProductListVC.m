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

#import "AlertUtil.h"

@interface ProductListVC ()
@property (nonatomic) NSMutableArray *products;
@end

@implementation ProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NavigationBar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorites"] style:UIBarButtonItemStylePlain target:self action:@selector(favoriteProducts)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filter icon"] style:UIBarButtonItemStylePlain target:self action:@selector(filterProducts)];
    
    [self initializeData];
    
    self.cvProductsCollection.delegate = self;
    self.cvProductsCollection.dataSource = self;
    [self.cvProductsCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNewProduct:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.imgNewProduct addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeData {
    [self.api productsViaCategory:@"" andDistance:@"" andWord:@"" Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
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
    
    [cell setImageWithURL:[cellData images][0]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    
    ProductDetailViewController *pdVC = [[ProductDetailViewController alloc] initWithProduct: product];
    [self.navigationController pushViewController:pdVC animated:YES];
}

#pragma mark - Navigation buttons action

-(void) favoriteProducts {
    
}

-(void) filterProducts {
    FilterProductsViewController *filVC = [[FilterProductsViewController alloc] init];
    [self presentViewController:filVC animated:YES completion:^{
        
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
