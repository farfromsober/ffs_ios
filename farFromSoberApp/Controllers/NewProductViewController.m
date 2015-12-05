//
//  NewProductViewController.m
//  farFromSoberApp
//
//  Created by Agustín on 05/12/2015.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "NewProductViewController.h"

#import "Product.h"
#import "ProductCategory.h"

#import "AlertUtil.h"

#import "AzureDefines.h"
#import "ABSManager.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface NewProductViewController ()

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) ABSManager *manager;

@property (nonatomic, strong) UIImage *imageSelected;

@end

@implementation NewProductViewController

#pragma mark - Inits
-(instancetype) initWithProduct: (Product *) produt {
    
    self = [super init];
    if (self) {
        _product = produt;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbTitle.delegate = self;
    self.lbCategory.delegate = self;
    self.lbPrice.delegate = self;
    
    [self.imgProduct1 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    [self.imgProduct2 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    [self.imgProduct3 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    [self.imgProduct4 setImage:[UIImage imageNamed:@"photo_placeholder"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons Action

- (IBAction)btSellIt:(id)sender {
    
    self.product.name = self.lbTitle.text;
    self.product.detail = self.lbDescription.text;
    
    //ProductCategory *category = [[ProductCategory alloc] init];
    //category.name
    //self.product.category
    
    self.product.price = self.lbPrice.text;
    
    NSDictionary *prod = [[Product alloc] objectToJSON:self.product];
    
    [self.api newProductViaProduct:prod Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)btAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Keyboar hide

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.lbTitle isFirstResponder] && [touch view] != self.lbTitle) {
        [self.lbTitle resignFirstResponder];
    } else if ([self.lbCategory isFirstResponder] && [touch view] != self.lbCategory) {
        [self.lbCategory resignFirstResponder];
    } else if ([self.lbPrice isFirstResponder] && [touch view] != self.lbPrice) {
        [self.lbPrice resignFirstResponder];
    }
    
    if ([touch view] == self.imgProduct1) {
        [self tapAddPhoto: self.imgProduct1];
    } else if ([touch view] == self.imgProduct2) {
        [self tapAddPhoto: self.imgProduct2];
    } else if ([touch view] == self.imgProduct3) {
        [self tapAddPhoto: self.imgProduct3];
    }else if ([touch view] == self.imgProduct4) {
        [self tapAddPhoto: self.imgProduct4];
    }
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextView delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0) {
        [self.lbDescription becomeFirstResponder];
    } else if (textField.tag == 1) {
        [self.lbCategory becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.lbPrice becomeFirstResponder];
    } else {
        [self btSellIt:nil];
    }
    
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! Pico de memoria asegurado, especialmente en
    // dispositivos antiguos
    
    
    // Sacamos la UIImage del diccionario
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.imageSelected = img;
    
}

#pragma mark - Tap Add photo
-(void) tapAddPhoto: (UIImageView *) imaView {
    
    // Creamos un UIImagePickerController
    UIImagePickerController *picker = [UIImagePickerController new];
    
    // Lo configuro
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Uso la cámara
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        // Tiro del carrete
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.delegate = self;
    
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Lo muestro de forma modal
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la
                         // animación que muestra al picker.
                         
                         imaView.image = self.imageSelected;
#warning Subir la foto aqui? o cuando le damos a vender? cambiar el nombre del blob
                         [self uploadPhoto:self.imageSelected];
                         
                         // Quito de encima el controlador que estamos presentando
                         [self dismissViewControllerAnimated:YES
                                                  completion:^{
                                                      // Se ejecutará cuando se haya ocultado del todo
                                                  }];
                     }];
    
}

-(void) uploadPhoto: (UIImage *) img {
    self.manager = [[ABSManager alloc] init];
    
    //UPLOAD IMAGE
    [self.manager giveMeSaSURLBlobName:@"test12.png"
                         containerName:AZURE_CONTAINER
                      completionSaSURL:^(NSURL *sasURL) {
                          if (sasURL != nil) {
                              [self.manager handleImageToUploadAzureBlob:sasURL
                                                                 blobImg:img
                                                    completionUploadTask:^(BOOL result, NSError *error) {
                                                       

                                                    }];
                          } else {
                              NSLog(@"Error al obtener la SAS URL");
                          }
                          
                      }];
}

@end
