//
//  LoginViewController.h
//  farFromSoberApp
//
//  Created by Agustín on 25/11/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;
@property (weak, nonatomic) IBOutlet UIButton *btRememberPass;
@property (weak, nonatomic) IBOutlet UIButton *btSignUp;
@property (weak, nonatomic) IBOutlet UIImageView *img4Sale;

- (IBAction)btLogin:(id)sender;
- (IBAction)btRememberPass:(id)sender;
- (IBAction)btSignUp:(id)sender;

@end
