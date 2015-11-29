//
//  BaseViewController.m
//  farFromSoberApp
//
//  Created by David Regatos on 11/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

#pragma mark - init

// init programatically
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if	(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    
    return self;
}

// init from nib file
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //after nib-loading
}

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Called after the controller's view is loaded into memory.
    // Set up initial/constant ATTRIBUTES of view's elements.
    self.api = [APIManager sharedManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Notifies the view controller that its view is about to be added to a view hierarchy.
    // Refresh the CONTENT&GEOMETRY of view's elements
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Notifies the view controller that its view just laid out its subviews.
    // Set up the GEOMETRY of subview's elements
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // All UI elements have been initialised and drawn
}

#pragma mark - Others

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
