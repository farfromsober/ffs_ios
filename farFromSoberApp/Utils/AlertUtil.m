//
//  UIAlertController+initializer.m
//  farFromSoberApp
//
//  Created by Agustín on 27/11/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "AlertUtil.h"
#import "NSString+Validator.h"

@implementation AlertUtil

-(UIAlertController *) alertwithTitle: (NSString *) title andMessage: (NSString *) message andYesButtonTitle: (NSString *) yesButtonTittle andNoButtonTitle: (NSString *) noButtonTitle {
    UIAlertController *alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    if ([NSString isEmpty:noButtonTitle]) {
        UIAlertAction *yesButton = [[self class] createdButtonActionWithTitle: yesButtonTittle andAction: alert];
        [alert addAction:yesButton];
    } else if ([NSString isEmpty:yesButtonTittle]){
        UIAlertAction *noButton = [[self class] createdButtonActionWithTitle: noButtonTitle andAction: alert];
        [alert addAction:noButton];
    } else {
        UIAlertAction *noButton = [[self class] createdButtonActionWithTitle: noButtonTitle andAction: alert];
        [alert addAction:noButton];
        
        UIAlertAction *yesButton = [[self class] createdButtonActionWithTitle: yesButtonTittle andAction: alert];
        [alert addAction:yesButton];
    }

    return alert;
}

+(UIAlertAction *) createdButtonActionWithTitle: (NSString *) title andAction: (UIAlertController *) alert{
    if ([NSString isEmpty:title]) {
        title = @"OK";
    }
    UIAlertAction* button = [UIAlertAction
                                actionWithTitle:title
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    return button;
}

@end
