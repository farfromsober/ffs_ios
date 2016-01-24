//
//  UserDataCollectionViewCell.m
//  farFromSoberApp
//
//  Created by Joan on 23/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import "UserDataCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "UserManager.h"

@implementation UserDataCollectionViewCell 

- (void)awakeFromNib {
    // Initialization code
}

- (void)setUser:(User *)user {
    if (user != _user) {
        _user = user;
        self.usernameLabel.text = user.username;
        self.localizationLabel.text = user.city == nil?@"":user.city;
        self.salesLabel.text = [NSString stringWithFormat:@"%@ vendidos", user.sales];
        [self.cellImageView sd_setImageWithURL:user.avatarURL
                           placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        
        self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.height /2;
        self.cellImageView.layer.masksToBounds = YES;
        self.cellImageView.layer.borderWidth = 0;
        
        [self.segmentedControl removeAllSegments];
        [self.segmentedControl insertSegmentWithTitle:@"En venta" atIndex:0 animated:NO];
        [self.segmentedControl insertSegmentWithTitle:@"Vendidos" atIndex:1 animated:NO];
        if (user.userId ==  [[UserManager sharedInstance] currentUser].userId) {
            [self.segmentedControl insertSegmentWithTitle:@"Comprados" atIndex:2 animated:NO];
        }
    }
}


- (IBAction)segmentedControlValueChanged:(id)sender {
    UserDataProductsListType type;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            type = UserDataProductsListTypeSelling;
            break;
        case 1:
            type = UserDataProductsListTypeSold;
            break;
        case 2:
            type = UserDataProductsListTypeBought;
            break;
        default:
            type = UserDataProductsListTypeSelling;
            break;
    }
    [self.delegate userDataCollectionViewCellSelectedOption:type];
}

@end
