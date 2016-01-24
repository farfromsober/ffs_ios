//
//  UserDataCollectionViewCell.h
//  farFromSoberApp
//
//  Created by Joan on 23/01/16.
//  Copyright © 2016 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef enum {
    UserDataProductsListTypeSelling,
    UserDataProductsListTypeSold,
    UserDataProductsListTypeBought
} UserDataProductsListType;


@protocol UserDataCollectionViewCellDelegate <NSObject>

- (void)userDataCollectionViewCellSelectedOption:(UserDataProductsListType)type;

@end

@interface UserDataCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localizationLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) id<UserDataCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) User *user;

@end
