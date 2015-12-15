//
//  ProductImageVC.h
//  farFromSoberApp
//
//  Created by Timple Soft on 15/12/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

@import UIKit;

@interface ProductImageVC : UIViewController

@property (nonatomic) NSUInteger pageIndex;

-(id) initWithImageURL:(NSURL *)imageURL
             pageIndex:(NSUInteger)index;

@end
