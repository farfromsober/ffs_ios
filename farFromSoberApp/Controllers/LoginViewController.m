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

#import "AppNavigation.h"

#import "AlertUtil.h"

@interface LoginViewController ()

@property (nonatomic, strong) APIManager *api;
@property (nonatomic, strong) UserManager *userM;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.api = [APIManager sharedManager];
    self.userM = [UserManager sharedInstance];
    
    self.txtUser.delegate = self;
    self.txtPass.delegate = self;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Button Action	

- (IBAction)btLogin:(id)sender {
    
    [self.api logInViaEmail:self.txtUser.text andPassword:self.txtPass.text Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        User *user = [[User alloc] initWithJSON:responseObject];
        
        if ([self.userM createUser:user]) {
            NSLog(@"Usuario creado correctamente: %@", user);
            
            [self.navigationController pushViewController:[AppNavigation tabBarController] animated:YES];
        }else {
            NSLog(@"Error al crear el usuario");
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Error: %@", error);
        
    }];
}

- (IBAction)btRememberPass:(id)sender {
}

- (IBAction)btSignUp:(id)sender {
}

#warning Crear KeyboardManager para ocultar el teclado
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txtUser isFirstResponder] && [touch view] != self.txtUser) {
        [self.txtUser resignFirstResponder];
    } else if ([self.txtPass isFirstResponder] && [touch view] != self.txtPass) {
        [self.txtPass resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextView delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0) {
        [self.txtPass becomeFirstResponder];
    } else {
        [self btLogin:nil];
    }
    
    return YES;
}

@end
