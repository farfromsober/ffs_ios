//
//  TableViewCell.m
//  farFromSoberApp
//
//  Created by Agustín on 06/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

#pragma mark -  Class Methods
+(CGFloat) height{
    return 25;
}

+(NSString *)cellId{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
}

-(void) syncCheck: (UIImage *) img{
    
    // Puede cambiar imagen y favoritos
    [UIView transitionWithView:self.imgCheck
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imgCheck.image = img;
                    } completion:nil];

}

#pragma mark - Cleanup
-(void) prepareForReuse{
    [super prepareForReuse];
    
    
    // hacemos limpieza
    [self cleanUp];
}

-(void) cleanUp{

    self.imgCheck.image = nil;
    self.lbName.text = nil;
}

@end
