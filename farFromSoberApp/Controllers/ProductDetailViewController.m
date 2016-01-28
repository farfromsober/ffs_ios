//
//  ProductDetailViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 01/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProductDetailViewController.h"

#import "Product.h"
#import "User.h"
#import "AppStyle.h"
#import "ProductImageVC.h"
#import "UserDetailVC.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"
#import "ProductListVC.h"

@interface ProductDetailViewController ()

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic) NSUInteger numPages;
@property (weak, nonatomic) ProductListVC *productList;


@end

@implementation ProductDetailViewController

#pragma mark - Init

-(instancetype) initWithProduct:(Product *)product productList:(id)productListVC{
    
    self = [super init];
    if (self) {
        _product = product;
        _productList = productListVC;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageViewController];
    [AppStyle styleProductDetailViewController:self];
    
    [self initializeData];
}




#pragma mark - Initialize Data

-(void) initializeData {
    
    [self.imgProfile sd_setImageWithURL:self.product.seller.avatarURL
                       placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height /2;
    self.imgProfile.layer.masksToBounds = YES;
    self.imgProfile.layer.borderWidth = 0;
    
    self.lbDateProfile.text = self.product.dateFormatted;
    self.lbDescriptionProduct.text = self.product.detail;
    self.lbNameProfile.text = self.product.seller.username;
    
    NSString *photos = [self.product.images count] == 1 ? @"1 Photo" : [NSString stringWithFormat:@"%lu Photos", [self.product.images count]];
    self.lbNumberPhotos.text = photos;
    self.lbNumberPhotos.layer.backgroundColor = [[UIColor colorWithRed:252/255.0f green:183/255.0f blue:151/255.0f alpha:1.0f] CGColor];
    self.lbNumberPhotos.layer.cornerRadius = 12;
    
    self.lbPrice.text = [NSString stringWithFormat:@"%@€",self.product.price];
    
    self.lbState.text = self.product.isSelling ? @"For sell" : @"Sold";
    self.lbState.layer.backgroundColor = [[UIColor colorWithRed:252/255.0f green:183/255.0f blue:151/255.0f alpha:1.0f] CGColor];
    self.lbState.layer.cornerRadius = 12;
    
    self.lbTitleProduct.text = self.product.name;
    
    // Ponemos la localización del producto y le añadimos un pin
    MKCoordinateRegion region;
    region.center = self.product.seller.location;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    [annotation setCoordinate:self.product.seller.location];
    [annotation setTitle:self.product.seller.username];
    [self.mvMap setRegion:region animated:YES];
    [self.mvMap addAnnotation:annotation];
    if (self.product.seller.userId ==  [[UserManager sharedInstance] currentUser].userId) {
        self.btBuyProduct.hidden = YES;
    }
}



#pragma mark - UIPageViewController

-(void) setupPageViewController {
    
    // preparamos el PageViewController
    self.numPages = [self.product.images count] == 0 ? 1 : [self.product.images count];
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                options:nil];
    self.pageVC.dataSource = self;
    [self.pageVC setViewControllers:@[[self viewControllerAtIndex:0]]
                          direction:UIPageViewControllerNavigationDirectionForward
                           animated:NO
                         completion:nil];
    self.pageVC.view.frame = self.imagesContainer.frame;
    [self.imagesContainer addSubview:self.pageVC.view];
    [self.imagesContainer bringSubviewToFront:self.lbNumberPhotos];
    [self.imagesContainer bringSubviewToFront:self.lbState];
    
    // PageControl
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.numPages;
    [self.pageControl setCurrentPage:0];
    [self.imagesContainer addSubview:self.pageControl];
    
    // Si no tenemos fotos o solo tenemos una ocultamos el pagecontrol
    if (self.numPages == 1) {
        [self.pageControl setHidden:YES];
    }
    
}



-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((ProductImageVC *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    [self.pageControl setCurrentPage:index];
    
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((ProductImageVC *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    [self.pageControl setCurrentPage:index];
    
    if (index == self.numPages) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (ProductImageVC *)viewControllerAtIndex:(NSUInteger)index{
    
    if (index >= self.numPages) {
        return nil;
    }
    
    ProductImageVC *pageVC;
    if ([self.product.images count] == 0) {
        pageVC = [[ProductImageVC alloc] initWithImageURL:nil
                                                pageIndex:index];
    } else {
        pageVC = [[ProductImageVC alloc] initWithImageURL:self.product.images[index]
                                                pageIndex:index];
    }
    return pageVC;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.numPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}



- (IBAction)goToUser:(id)sender {
    UserDetailVC *userDetailVC = [[UserDetailVC alloc] initWithUser:self.product.seller];
    [self.navigationController pushViewController:userDetailVC animated:YES];
}

- (IBAction)buyProduct:(id)sender {
    MBProgressHUD *hud = [AppStyle getLoadingHUDWithView:self.view message:@"Comprando"];
    [self.api buyProductWithId:self.product.productId Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        [[self.productList products] removeObject:self.product];
        [hud hide:YES afterDelay:1];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MBProgressHUD *hud = [AppStyle getLoadingHUDWithView:self.view message:@"Ha ocurrido un error al realizar la compra"];
        [hud hide:YES afterDelay:2];
    }];
}


@end
