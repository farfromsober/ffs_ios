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

@interface ProfileVC ()

@property (strong, nonatomic) MBProgressHUD *hud;

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
    
    [self getProductsWithUser];
    
    self.lbName.text = [NSString stringWithFormat:@"%@|%@|%@",[user firstName],@" ",[user lastName]];
    
    self.lbLocation.text = [user city];
    self.lbSalesNbr.text = [[user sales] stringValue];

    NSUInteger purchases = [self.purchasedProducts count];
    
    self.lbPurchasesNbr.text = [NSString stringWithFormat:@"%@",  @(purchases)];
    
    [self.imgAvatar sd_setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
}

- (void) getProductsWithUser {
    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Loading products"];
    UserManager *manager = [UserManager sharedInstance];
    User *user = [manager currentUser];
    
    
    
    [self.api productsForUser: user.username selling: 2 Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        self.soldProducts = [NSMutableArray new];
        
        for (NSDictionary *productDic in responseObject) {
            Product *product = [[Product alloc] initWithJSON:productDic];
            [self.soldProducts addObject:product];
        }
        
        
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



@end
