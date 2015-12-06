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

-(instancetype) initWithIndexCategorySelected: (NSInteger) indexCategory andIndexDistance: (NSInteger) indexDistance {
    self = [super init];
    
    if (self) {
        _indexCategorySelected = indexCategory >= 0 ? [NSIndexPath indexPathForRow:indexCategory inSection:0] : nil;
        _indexDistanceSelected = indexDistance >= 0 ? [NSIndexPath indexPathForRow:indexDistance inSection:0] : nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register nib
    [self registerNib];
    
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
        if (self.indexCategorySelected && indexPath.row == self.indexCategorySelected.row) {
            cell.imgCheck.image = [UIImage imageNamed:@"circleCheck"];
        }else{
            cell.imgCheck.image = [UIImage imageNamed:@"checkOff"];
        }
        
        
    } else {
        cell.lbName.text = @"Test";
        /*if (cellData.index == self.indexDistance) {
            cell.imgCheck.image = [UIImage imageNamed:@"checkOff"];
        }else{
            cell.imgCheck.image = [UIImage imageNamed:@"checkOff"];
        }*/
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
        if (self.indexCategorySelected && self.indexCategorySelected.row == indexPath.row) {
            self.indexCategorySelected = nil;
            cell.imgCheck.image = [UIImage imageNamed:@"checkOff"];
        } else {
            self.indexCategorySelected = indexPath;
            cell.imgCheck.image = [UIImage imageNamed:@"circleCheck"];
        }
        
        
    } else {
        if (self.indexDistanceSelected && self.indexDistanceSelected.row >= 0) {
            FilterTableViewCell *cellSelected = [tableView cellForRowAtIndexPath:self.indexDistanceSelected];
            cellSelected.imgCheck.image = [UIImage imageNamed:@"checkOff"];
            
        }
        self.indexDistanceSelected = indexPath;
        cell.imgCheck.image = [UIImage imageNamed:@"circleCheck"];
    }
    
    
    
}

#pragma mark - Buttons Action

- (IBAction)btCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)btSave:(id)sender {
    
    if([self.myDelegate respondsToSelector:@selector(filterProductsViewControllerDismissed:indexDistance:)])
    {
        //Sumamos 1 ya que en la api el index comienza en 1
        NSString *indexC = self.indexCategorySelected ? [NSString stringWithFormat:@"%ld",self.indexCategorySelected.row + 1] : @"";
        NSString *indexD = self.indexDistanceSelected ? [NSString stringWithFormat:@"%ld",self.indexDistanceSelected.row + 1] : @"";
        [self.myDelegate filterProductsViewControllerDismissed:indexC indexDistance:indexD];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Register cell

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