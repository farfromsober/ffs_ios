//
//  LoginViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 25/11/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "LoginViewController.h"
#import "APIManager.h"
#import "User.h"

#import "UserManager.h"
#import "DRGKeyboardManager.h"

#import "AppStyle.h"
#import "AppNavigation.h"
#import "AlertUtil.h"

@interface LoginViewController () <UITextFieldDelegate, DRGKeyboardManagerDelegate>

@property (nonatomic, strong) APIManager *api;
@property (nonatomic, strong) UserManager *userManager;
@property (nonatomic, strong) DRGKeyboardManager *kbManager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.api = [APIManager sharedManager];
    self.userManager = [UserManager sharedInstance];
    self.kbManager = [[DRGKeyboardManager alloc] initForViewController:self];
    self.kbManager.delegate = self;
    
    self.txtUser.delegate = self;
    self.txtPass.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppStyle styleLoginViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.kbManager beginObservingKeyboard:[NSNotificationCenter defaultCenter]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.kbManager endObservingKeyboard];
}

#pragma mark - Button Action	

- (IBAction)didSelectBackground:(UIControl *)sender {
    [self.view endEditing:YES];
}

- (IBAction)btLogin:(id)sender {
    
    [self.api logInViaEmail:self.txtUser.text andPassword:self.txtPass.text Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        User *user = [[User alloc] initWithJSON:responseObject];
        
        if (![self.userManager createUser:user]) {
            NSLog(@"Error al crear el usuario");
            [self showAlertWithMessage:@"Sorry. Unable to create User"];
        }
        
        NSLog(@"Usuario creado correctamente: %@", user);
        [AppNavigation onLoginFromViewController:self];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showAlertWithMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"]];
    }];
}

- (IBAction)btRememberPass:(id)sender {
    
}

- (IBAction)btSignUp:(id)sender {
    
}

#pragma mark - UITextView delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0) {
        [self.txtPass becomeFirstResponder];
    } else {
        [self didSelectBackground:nil];
        [self performSelector:@selector(btLogin:) withObject:nil afterDelay:0.6];
    }
    
    return YES;
}

#pragma mark - DRGKeyboardManagerDelegate

- (void)keyboardManagerDidShowKeyboard:(DRGKeyboardManager *)kbManager {
    if (self.img4Sale.frame.origin.y < 0) {
        // hide logo image if it isn't full visible
        [UIView animateWithDuration:0.2 animations:^{
            self.img4Sale.alpha = 0.0;
        }];
    }
}

- (void)keyboardManagerDidHideKeyboard:(DRGKeyboardManager *)kbManager {
    if (self.img4Sale.alpha == 0.0) {
        // show logo image again
        [UIView animateWithDuration:0.2 animations:^{
            self.img4Sale.alpha = 1.0;
        }];
    }
}

#pragma mark - Utils

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error"
                                                       andMessage:message
                                                andYesButtonTitle:@""
                                                 andNoButtonTitle:@"Close"];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
