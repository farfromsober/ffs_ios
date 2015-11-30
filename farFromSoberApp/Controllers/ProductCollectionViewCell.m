//
//  ProductoCollectionViewCell.m
//  farFromSoberApp
//
//  Created by Agustín on 29/11/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "ProductCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ProductCollectionViewCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ProductCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

-(void) setImageWithURL: (NSURL *) url {
    [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:@"https://www.facebookbrand.com/img/fb-art.jpg"]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

@end
