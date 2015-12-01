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

#import "AlertUtil.h"

@interface ProductListVC ()
@property (nonatomic) NSMutableArray *products;
@end

@implementation ProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    
    self.cvProductsCollection.delegate = self;
    self.cvProductsCollection.dataSource = self;
    [self.cvProductsCollection registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"productCell"];
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
        
#warning BorrarRRRRRRR
        self.products = [NSMutableArray new];
        
        for (NSDictionary *productDic in [self dummyData]) {
            Product *product = [[Product alloc] initWithJSON:productDic];
            [self.products addObject:product];
        }
        
        [self.cvProductsCollection reloadData];
    }];
  
}

#warning DummyData BorrarrrrRRRR
-(NSArray *) dummyData {
    NSMutableArray *dicRet = [NSMutableArray new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"5649b6eae9a246eed43f0174" forKey:@"_id"];
    [dic setObject:@"true" forKey:@"selling"];
    [dic setObject:@"2015-11-02T14:16:29+00:00" forKey:@"published_date"];
    [dic setObject:@"387.96" forKey:@"price"];
    [dic setObject:@"tempor in laboris" forKey:@"name"];
    [dic setObject:@"mollit nisi nisi ea exercitation deserunt anim et cupidatat fugiat ullamco fugiat amet irure cillum aute Lorem est nostrud" forKey:@"description"];

    NSMutableDictionary *seller = [NSMutableDictionary new];
    
    [seller setObject:@"5649ae77dbca133e4e385a58" forKey:@"_id"];
    [seller setObject:@"jmartinez" forKey:@"username"];
    [seller setObject:@"Julio" forKey:@"first_name"];
    [seller setObject:@"Marinez" forKey:@"last_name"];
    [seller setObject:@"juliomb89@gmail.com" forKey:@"email"];
    
    [dic setObject:seller forKey:@"seller"];
    
    NSMutableArray *fotos = [NSMutableArray new];
    
    [fotos addObject:@"http://placehold.it/350x350"];
    [fotos addObject:@"http://placehold.it/350x350"];
    
    [dic setObject:fotos forKey:@"images"];
    
    [dicRet addObject:dic];
    [dicRet addObject:dic];
    [dicRet addObject:dic];
    [dicRet addObject:dic];
    [dicRet addObject:dic];
    [dicRet addObject:dic];
    [dicRet addObject:dic];
    
    return dicRet;
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
    
    cell.lbPrice.text = [cellData price];
    cell.lbTitle.text = [cellData name];
    
    [cell setImageWithURL:[cellData images][0]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [self.products objectAtIndex:indexPath.row];
    
    ProductDetailViewController *pdVC = [[ProductDetailViewController alloc] initWithProduct: product];
    [self.navigationController pushViewController:pdVC animated:YES];
}

@end
