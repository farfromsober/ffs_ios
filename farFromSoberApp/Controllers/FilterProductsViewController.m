//
//  FilterProductsViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 06/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "FilterProductsViewController.h"

#import "ProductCategory.h"
#import "CategoryManager.h"

#import "FilterTableViewCell.h"

@interface FilterProductsViewController ()

@property (nonatomic, strong) CategoryManager *cateManager;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, strong) NSIndexPath *indexCategorySelected;
@property (nonatomic, strong) NSIndexPath *indexDistanceSelected;

@end

@implementation FilterProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register nib
    [self registerNib];
    
    //Init category and distance selected
    //self.indexCategorySelected = [NSIndexPath init];
    //self.indexDistanceSelected = [NSIndexPath init];
    
    // Set height for all cells
    self.tvCategories.rowHeight = [FilterTableViewCell height];
    self.tvDistance.rowHeight = [FilterTableViewCell height];
    
    self.tvCategories.delegate = self;
    self.tvCategories.dataSource = self;
    self.tvDistance.delegate = self;
    self.tvDistance.dataSource = self;
    
    self.cateManager = [CategoryManager sharedInstance];
    self.categories = [self.cateManager loadCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViews

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tvCategories) {
        return @"CATEGORIES";
    } else {
        return @"DISTANCE";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tvCategories) {
        return [self.categories count];
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FilterTableViewCell cellId]];
    
    if (tableView == self.tvCategories) {

        ProductCategory *cellData = [self.categories objectAtIndex:indexPath.row];
        
        cell.lbName.text = cellData.name;
        cell.imgCheck.image = [UIImage imageNamed:@"checkOff"];
        
    } else {
        cell.lbName.text = @"Test";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == self.tvCategories) {
        
        if (self.indexCategorySelected && self.indexCategorySelected.row >= 0) {
            FilterTableViewCell *cellSelected = [tableView cellForRowAtIndexPath:self.indexCategorySelected];
             cellSelected.imgCheck.image = [UIImage imageNamed:@"checkOff"];
            
        }
        self.indexCategorySelected = indexPath;
        cell.imgCheck.image = [UIImage imageNamed:@"circleCheck"];
        
    } else {
        if (self.indexDistanceSelected && self.indexDistanceSelected.row >= 0) {
            FilterTableViewCell *cellSelected = [tableView cellForRowAtIndexPath:self.indexDistanceSelected];
            cellSelected.imgCheck.image = [UIImage imageNamed:@"checkOff"];
            
        }
        self.indexDistanceSelected = indexPath;
        cell.imgCheck.image = [UIImage imageNamed:@"circleCheck"];
    }
    
    
    
}

- (IBAction)btCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)btSave:(id)sender {
}

-(void) registerNib{
    
    UINib *nib = [UINib nibWithNibName:@"FilterTableViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.tvCategories registerNib:nib
         forCellReuseIdentifier:[FilterTableViewCell cellId]];
    
    
    UINib *nibDistance = [UINib nibWithNibName:@"FilterTableViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.tvDistance registerNib:nibDistance
            forCellReuseIdentifier:[FilterTableViewCell cellId]];
    
    
}

@end
