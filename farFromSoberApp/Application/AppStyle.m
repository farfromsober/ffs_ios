//
//  AppStyle.m
//  farFromSoberApp
//
//  Created by David Regatos on 06/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "AppStyle.h"
#import "AppConstants.h"
#import "LoginViewController.h"
#import "ProductCollectionViewCell.h"
#import "ProductDetailViewController.h"
#import "FilterProductsViewController.h"
#import "ProfileVC.h"


static NSUInteger const navBarIconWidth = 27;
static NSUInteger const navBarIconHeight = 25;


@implementation AppStyle

#pragma mark - Colors

+ (UIColor *)mainColorLight {
    return [UIColor colorWithRed:252.0f/255.0f green:218.0f/255.0f blue:202.0f/255.0f alpha:1.0f];
}

+ (UIColor *)mainColorDark {
    return [UIColor colorWithRed:252.0f/255.0f green:114.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_veryLightPinkColor {
    return [UIColor colorWithRed:252.0f/255.0f green:235.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_lightPeachColor {
    return [UIColor colorWithRed:252.0f/255.0f green:218.0f/255.0f blue:202.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_lightSalmonColor {
    return [UIColor colorWithRed:252.0f/255.0f green:183.0f/255.0f blue:151.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_paleOrangeColor {
    return [UIColor colorWithRed:252.0f/255.0f green:149.0f/255.0f blue:101.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_orangishColor {
    return [UIColor colorWithRed:252.0f/255.0f green:114.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_blackColor {
    return [UIColor colorWithRed:41.0f/255.0f green:37.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_whiteColor {
    return [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)si_charcoalGreyColor {
    return [UIColor colorWithRed:41.0f/255.0f green:47.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
}

#pragma mark - Fonts

+ (UIFont *)fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)fontBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+ (UIFont *)fontThinWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

+ (UIFont *)fontMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

#pragma mark - Global

+ (void)applyGlobalStyles {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

+ (void)styleNavBar:(UINavigationBar *)navBar {
    //NavigationBar
    navBar.tintColor = [AppStyle si_whiteColor];
    navBar.barTintColor = [AppStyle si_orangishColor];
    navBar.translucent = NO;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if (![navBar viewWithTag:[AppConstants searchBarTag]]) {
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(navBar.frame.size.width/2 - navBarIconWidth/2,
                                                                                   navBar.frame.size.height/2 - navBarIconHeight/2,
                                                                                   navBarIconWidth, navBarIconHeight)];
        iconImageView.image = [UIImage imageNamed:@"navBarLogo"];
        iconImageView.tag = [AppConstants searchBarTag];
        [navBar addSubview:iconImageView];
    }
    
}

+ (void)hideLogo:(BOOL)hide ToNavBar:(UINavigationBar *) navBar {
    UIView *logo = [navBar viewWithTag:[AppConstants searchBarTag]];
    logo.hidden = hide;
}

+ (void)addSearchBarToNavBar:(UINavigationBar *) navBar {
    UISearchBar *searchBar = [UISearchBar new];
    [searchBar sizeToFit];
    searchBar.backgroundColor = [AppStyle mainColorDark];
    searchBar.barTintColor = [AppStyle mainColorDark];
    navBar.topItem.titleView = searchBar;
}

+ (void)removeSearchBarFromNavBar:(UINavigationBar *) navBar {
    
    
}

#pragma mark - LoginViewController

+ (void)styleLoginViewController:(LoginViewController *)vc {
    
    vc.view.backgroundColor = [self si_lightPeachColor];
    
    vc.img4Sale.image = [UIImage imageNamed:@"4sale!.png"];
    
    vc.usernameLabel.text = @"USERNAME";
    vc.passwordLabel.text = @"PASSWORD";
    [vc.btRememberPass setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [vc.btSignUp setTitle:@"Sign up" forState:UIControlStateNormal];
    [vc.btLogin setTitle:@"Sign in" forState:UIControlStateNormal];

    [AppStyle styleTextFieldLabel:vc.usernameLabel];
    [AppStyle styleTextFieldLabel:vc.passwordLabel];
    [AppStyle styleTextField:vc.txtUser];
    [AppStyle styleTextField:vc.txtPass];
    [AppStyle styleNormalButton:vc.btRememberPass];
    [AppStyle styleNormalButton:vc.btSignUp];
    [AppStyle styleRoundedButton:vc.btLogin];
}

#pragma mark - ProductVC

+ (void)styleProductCell:(ProductCollectionViewCell *)cell {
    
    cell.backgroundColor = [AppStyle si_whiteColor];
    
    cell.layer.cornerRadius = 5.0;
    cell.layer.borderColor = [AppStyle si_orangishColor].CGColor;
    cell.layer.borderWidth = 3.0;
    cell.layer.masksToBounds = YES;
    
    cell.imgProduct.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgProduct.backgroundColor = [AppStyle si_lightSalmonColor];
    cell.lbTitle.font = [AppStyle fontWithSize:11];
    cell.lbTitle.textColor = [AppStyle si_blackColor];
    cell.lbPrice.font = [AppStyle fontBoldWithSize:13];
    cell.lbPrice.textColor = [AppStyle si_blackColor];
}


+ (void)styleProductDetailViewController:(ProductDetailViewController *)vc{

    vc.lbPrice.font = [AppStyle fontWithSize:24];
    vc.lbNameProfile.font = [AppStyle fontWithSize:14];
    vc.lbDateProfile.font = [AppStyle fontWithSize:11];
    vc.lbTitleProduct.font = [AppStyle fontBoldWithSize:13];
    vc.lbDescriptionProduct.font = [AppStyle fontWithSize:12];
    vc.lbState.font = [AppStyle fontWithSize:14];
    vc.lbNumberPhotos.font = [AppStyle fontWithSize:14];
    vc.lbLocation.font = [AppStyle fontWithSize:14];
    
    vc.btBuyProduct.titleLabel.font = [AppStyle fontMediumWithSize:16];
    
    NSUInteger width = 100;
    NSUInteger height = 30;
    vc.pageControl.frame = CGRectMake((vc.imagesContainer.frame.size.width/2)-(width/2),
                                      vc.imagesContainer.frame.size.height-height,
                                      width, height);
    vc.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    vc.pageControl.currentPageIndicatorTintColor = [AppStyle si_orangishColor];
    
}


+ (void)styleFilterProductsViewController:(FilterProductsViewController *)vc{
    
    vc.lbFilter.font = [AppStyle fontBoldWithSize:17];
    
    vc.btCancel.titleLabel.font = [AppStyle fontWithSize:17];
    vc.btSave.titleLabel.font = [AppStyle fontWithSize:17];
    
    vc.lbDistance.font = [AppStyle fontBoldWithSize:13];
    vc.lbDistance.textColor = [AppStyle si_whiteColor];
    vc.lbCategories.font = [AppStyle fontBoldWithSize:13];
    vc.lbCategories.textColor = [AppStyle si_whiteColor];
    
    
}

+ (void)styleProfileViewController:(ProfileVC *)vc{
    
    vc.lbName.font = [AppStyle fontWithSize:14];
    vc.lbName.textColor = [AppStyle si_orangishColor];
    vc.lbLocation.font = [AppStyle fontWithSize:12];
    vc.lbPurchases.font =  [AppStyle fontWithSize:12];
    vc.lbPurchasesNbr.font =  [AppStyle fontWithSize:12];
    vc.lbSales.font =  [AppStyle fontWithSize:12];
    vc.lbSalesNbr.font =  [AppStyle fontWithSize:12];
    vc.buttonsControl.backgroundColor = [AppStyle si_lightPeachColor];
    vc.buttonsControl.tintColor = [AppStyle si_orangishColor];
    vc.viewProducts.backgroundColor = [AppStyle si_lightPeachColor];
    vc.scrollViewProducts.backgroundColor= [AppStyle si_lightPeachColor];
    vc.cvProductsCollection.backgroundColor= [AppStyle si_lightPeachColor];

    

    
}



#pragma mark - Shared

+ (void)styleTextFieldLabel:(UILabel *)label {
    label.textColor = [self si_orangishColor];
    label.font = [AppStyle fontWithSize:10];
}

+ (void)styleTextField:(UITextField *) txtField {
    txtField.clipsToBounds = YES;
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtField.textColor = [self si_orangishColor];
    txtField.tintColor = [self si_orangishColor];
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.layer.borderColor = [self si_lightSalmonColor].CGColor;
    txtField.layer.borderWidth = 1.0;
    txtField.layer.cornerRadius = 5.0;
}

+ (void)styleRoundedButton:(UIButton *)btn {
    btn.titleLabel.font = [AppStyle fontBoldWithSize:17.0];
    btn.backgroundColor = [self si_orangishColor];
    [btn setTitleColor:[self si_whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0;
}

+ (void)styleNormalButton:(UIButton *)btn {
    btn.titleLabel.font = [AppStyle fontBoldWithSize:12.0];
    [btn setTitleColor:[self si_orangishColor] forState:UIControlStateNormal];
}

#pragma mark - Loading HUD

+(MBProgressHUD *) getLoadingHUDWithView: (UIView *) view
                                 message: (NSString *) message{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.activityIndicatorColor = [UIColor blackColor];
    hud.labelText = message;
    hud.labelColor = [UIColor blackColor];
    hud.minShowTime = 0.75;
    hud.color = [self mainColorDark];
    
    return hud;
}


@end
