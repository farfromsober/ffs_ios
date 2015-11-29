//
//  UIAlertController+initializer.h
//  farFromSoberApp
//
//  Created by Agustín on 27/11/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface AlertUtil : NSObject

-(UIAlertController *) alertwithTitle: (NSString *) title andMessage: (NSString *) message andYesButtonTitle: (NSString *) yesButtonTittle andNoButtonTitle: (NSString *) noButtonTitle;

@end
