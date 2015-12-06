//
//  FilterProductsViewController.h
//  farFromSoberApp
//
//  Created by Agustín on 06/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterProductsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btCancel;
@property (weak, nonatomic) IBOutlet UIButton *btSave;
@property (weak, nonatomic) IBOutlet UITableView *tvCategories;
@property (weak, nonatomic) IBOutlet UITableView *tvDistance;

- (IBAction)btCancel:(id)sender;
- (IBAction)btSave:(id)sender;
@end
