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
#import "User.h"

#import "CategoryManager.h"

#import "AlertUtil.h"
#import "UserManager.h"

#import "AzureDefines.h"
#import "ABSManager.h"

#import "NSDate+Parser.h"
#import "AppStyle.h"
#import "AppConstants.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface NewProductViewController ()

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) ProductCategory *productCategory;
@property (nonatomic, strong) ABSManager *manager;
@property (nonatomic, strong) UserManager *userM;
@property (nonatomic, strong) CategoryManager *cateManager;
@property (nonatomic, copy) NSArray *categories;

@property (nonatomic) NSInteger imageSelectedTag;
@property (nonatomic, copy) NSMutableArray *images;
@property (strong, nonatomic) UIPickerView *pkCategories;

@end

@implementation NewProductViewController

#pragma mark - Inits
-(instancetype) initWithProduct: (Product *) product {
    
    self = [super init];
    if (self) {
        _product = product;
        _images = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userM = [UserManager sharedInstance];
    
    self.cateManager = [CategoryManager sharedInstance];
    self.categories = [self.cateManager loadCategories];
    
    self.lbTitle.delegate = self;
    self.lbCategory.delegate = self;
    self.lbPrice.delegate = self;
    self.lbDescription.delegate = self;
    
    [self.imgProduct1 setImage:[UIImage imageNamed:@"new_product_photo_placeholder"]];
    [self.imgProduct2 setImage:[UIImage imageNamed:@"new_product_photo_placeholder"]];
    [self.imgProduct3 setImage:[UIImage imageNamed:@"new_product_photo_placeholder"]];
    [self.imgProduct4 setImage:[UIImage imageNamed:@"new_product_photo_placeholder"]];
    
    [self.imgProduct2 setHidden:YES];
    [self.imgProduct3 setHidden:YES];
    [self.imgProduct4 setHidden:YES];
    
    self.pkCategories = [[UIPickerView alloc] init];
    //self.pkCategories.backgroundColor = [AppStyle mainColorLight];
    self.lbCategory.inputView =self.pkCategories;
    self.pkCategories.delegate = self;
    self.pkCategories.dataSource = self;
}

#pragma mark - Buttons Action

- (IBAction)btSellIt:(id)sender {
    
    self.product.name = self.lbTitle.text;
    self.product.detail = self.lbDescription.text;
    self.product.category = self.productCategory;
    self.product.price = self.lbPrice.text;
    
    NSDictionary *prod = [[Product alloc] objectToJSON:self.product];
    
    for (int i=0; i<[self.images count]; i++) {
        UIImageView *photoToUpload = [self getImageWithTag:(int)[self.images objectAtIndex:i]];
        [self uploadPhoto:photoToUpload.image];
    }
    
    //[self uploadPhoto:self.imgProduct1.image];
    /*
    [self.api newProductViaProduct:prod Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        [self uploadPhoto:self.imgProduct1.image];
        [self uploadPhoto:self.imgProduct2.image];
        [self uploadPhoto:self.imgProduct3.image];
        [self uploadPhoto:self.imgProduct4.image];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Error: %@", error);
    }];*/
}

- (IBAction)btAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard hide and events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.lbTitle isFirstResponder] && [touch view] != self.lbTitle) {
        [self.lbTitle resignFirstResponder];
    } else if ([self.lbPrice isFirstResponder] && [touch view] != self.lbPrice) {
        [self.lbPrice resignFirstResponder];
    } else if ([self.lbDescription isFirstResponder] && [touch view] != self.lbDescription) {
        [self.lbDescription resignFirstResponder];
    } else if ([self.lbCategory isFirstResponder] && [touch view] != self.lbCategory) {
        [self.lbCategory resignFirstResponder];
    }
    
    if ([touch view] == self.imgProduct1) {
        [self checkRemoveImage:self.imgProduct1];
    } else if ([touch view] == self.imgProduct2) {
        [self checkRemoveImage:self.imgProduct2];
    } else if ([touch view] == self.imgProduct3) {
        [self checkRemoveImage:self.imgProduct3];
    }else if ([touch view] == self.imgProduct4) {
        [self checkRemoveImage:self.imgProduct4];
    }
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextView & UITextField delegates

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 2) {
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text length] == 0) {
        if([textView.text length] != 0) {
            return YES;
        }
    } else if([[textView text] length] > [AppConstants maxPermitedChars] - 1) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    int textLength = (int)textView.text.length;
    self.lbDescriptionLength.text = [NSString stringWithFormat:@"%i/%i",textLength, [AppConstants maxPermitedChars]];
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! Pico de memoria asegurado, especialmente en
    // dispositivos antiguos
    
    // Sacamos la UIImage del diccionario
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Resize the image to 800x600
    if (img.size.height > img.size.width) {
        img = [self scaleImage:img toSize:CGSizeMake(600.0f,800.0f)];
    } else if (img.size.height < img.size.width){
        img = [self scaleImage:img toSize:CGSizeMake(800.0f,600.0f)];
    } else {
        img = [self scaleImage:img toSize:CGSizeMake(800.0f,800.0f)];
    }
    
    //Compress the image
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.5f;
    
    NSData *imageData = UIImageJPEGRepresentation(img, compression);
    
    while ([imageData length] > 75000 && compression > maxCompression)
    {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(img, compression);
        NSLog(@"Compress : %lu",(unsigned long)imageData.length);
    }
    
    UIImageView *actualPhoto = [self getImageWithTag:self.imageSelectedTag];
    //actualPhoto.image = img;
    actualPhoto.image = [UIImage imageWithData:imageData];
    
    // Añadimos el tag de la imagen al array de imágenes añadidas.
    [self.images addObject:@(actualPhoto.tag)];
    
    UIImageView *nextPhoto = [self getImageWithTag:self.imageSelectedTag+1];
    nextPhoto.hidden = NO;

    // Quito de encima el controlador que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UIImageView Utils

- (UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImageView *) getImageWithTag:(NSInteger) tag {
    
    switch (tag) {
        case 5:
            return self.imgProduct1;
            break;
        case 6:
            return self.imgProduct2;
            break;
        case 7:
            return self.imgProduct3;
            break;
        default:
            return self.imgProduct4;
            break;
    }
}

#pragma mark - Photo methods

-(void) checkRemoveImage: (UIImageView *) imageView {
    self.imageSelectedTag = imageView.tag;
    
    // Si la imagen ya ha sido añadida con anterioridad
    if ([self.images containsObject:@(self.imageSelectedTag)]) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Product photo"
                                      message:@"What do you want to do with this picture?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* addNew = [UIAlertAction
                                 actionWithTitle:@"Add New"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [self tapAddPhoto:imageView];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        UIAlertAction* remove = [UIAlertAction
                                 actionWithTitle:@"Remove"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [self removePhoto:imageView];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [alert addAction:addNew];
        [alert addAction:remove];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self tapAddPhoto:imageView];
    }
}

-(void) removePhoto:(UIImageView *) imageView {
    
    NSUInteger actualImagesCount = [self.images count];
    int imageToRemoveIndex = (int)[self.images indexOfObject:@(imageView.tag)];
    
    for (int i = imageToRemoveIndex; i<actualImagesCount; i++) {
        //Intercambiamos la imagen con la del ImageView posterior
        NSInteger actualTag = [[self.images objectAtIndex:i] integerValue];
        UIImageView *actualImageView = [self getImageWithTag:actualTag];
        UIImageView *nextImageView = [self getImageWithTag:actualTag + 1];
        [actualImageView setImage: nextImageView.image];
        if (i == actualImagesCount - 1) {
            //Si es la última imagen, la ponemos el placeholder y ocultamos la posterior
            [actualImageView setImage: [UIImage imageNamed:@"new_product_photo_placeholder"]];
            UIImageView *lastImageView = [self getImageWithTag:actualTag+1];
            lastImageView.hidden = YES;
        }
    }
    // Eliminamos el último tag del array de imágenes
    [self.images removeLastObject];
}

-(void) tapAddPhoto: (UIImageView *) imageView {
    
    // Creamos un UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
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
                     completion:nil];
    
}

-(void) uploadPhoto: (UIImage *) img {
    self.manager = [[ABSManager alloc] init];
    
    if (img) {
        User *user = [self.userM currentUser];
        NSString *now = [NSDate stringWithISO8601FormatDate:[NSDate new]];
        
        NSString *blobName = [NSString stringWithFormat:@"%@-%@",[user userId], now];
        
        //UPLOAD IMAGE
        [self.manager giveMeSaSURLBlobName:blobName
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
}

#pragma mark - Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.categories.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.categories objectAtIndex:row] name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.productCategory = [self.categories objectAtIndex:row];
    self.lbCategory.text = [[self.categories objectAtIndex:row] name];
    [self.lbCategory resignFirstResponder];
}
@end
