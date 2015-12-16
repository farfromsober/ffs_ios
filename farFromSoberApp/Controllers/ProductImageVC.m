//
//  ProductImageVC.m
//  farFromSoberApp
//
//  Created by Timple Soft on 15/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProductImageVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProductImageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) NSURL *imageURL;

@end

@implementation ProductImageVC

-(id) initWithImageURL:(NSURL *)imageURL
             pageIndex:(NSUInteger)index{
    
    if (self = [super init]) {
        _imageURL = imageURL;
        _pageIndex = index;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView sd_setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@"photo_placeholder_frame"]];
}

@end
