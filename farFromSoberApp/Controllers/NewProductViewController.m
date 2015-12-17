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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MBProgressHUD.h"
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
@property (nonatomic, copy) NSMutableArray *temporaryImageNsurls;

@property (strong, nonatomic) MBProgressHUD *hud;

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

// Botón de venta
- (IBAction)btSellIt:(id)sender {
    
    // Desactivamos botones y vistas...
    [self enableButtons:NO];
    
    // Comprobamos que los campos (titulo, descripción, categoría y precio) contienen datos ...
    if ([self hasNeededInformation]) {
        
        // ... Nos suscribimos a la señal del método que comprueba si hay fotos para subir ...
        [[self hasPhotosToUpload] subscribeNext:^(id userResponse) {
            
            // ... Si el usuario quiere continuar con la subida del producto (ya sea con imágenes o sin imágenes)
            if ([userResponse boolValue]) {
                //dispatch_async(dispatch_get_main_queue(), ^{
                    self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Uploading product"];
                //});
                
                // Continuar con carga de imágenes creando un array de señales.
                NSMutableArray *requestSignals = [NSMutableArray array];
                // Para cada una de las imágenes que el usuario ha guardado creamos una señal y la añadimos al array de señales.
                for (int i=0; i<[self.images count]; i++) {
                    UIImageView *photoToUpload = [self getImageWithTag:[[self.images objectAtIndex:i] integerValue]];
                    // La señal se crea a través del método uploadPhoto, el cuál devuelve una señal.
                    RACSignal *jsonSignal = [[self uploadPhoto:photoToUpload] catch:^(NSError *error) {
                        // ... En caso de que el método subida de esta imagen de error entramos aquí, devolviendo una señal de error.
                        return [RACSignal error:error];
                    }];
                    // .. Añadimos la señal de esta imagen al array de señales.
                    [requestSignals addObject:jsonSignal];
                }
                
                // Creamos una rac sequence a través del array de señales.
                RACSignal *requestSignalsSignal = requestSignals.rac_sequence.signal;
                RACSignal *results = [requestSignalsSignal flatten];
                
                // Finalmente, nos suscribimos al resultado de todas las señales del array mediante este método subscribeError:completed.
                [results subscribeError:^(NSError *error) {
                    // Entraremos en esta parte si alguna de las señales de los métodos de subida de cada imagen ha dado error.
                    // Mostraremos un alertview preguntando al usuario si quiere subir el producto sin imágenes o cancelar la subida.
                    //NSLog(@"Error subiendo alguna imagen");
                    
                    [self disableLoadingHUD];
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Error uploading images"
                                                  message:@"Want to upload the product without photos?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* upload = [UIAlertAction
                                             actionWithTitle:@"Yes"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 // ... en caso de aceptar, continuamos la subida del producto sin imágenes.
                                                 [self uploadProduct];
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                    UIAlertAction* cancel = [UIAlertAction
                                             actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 // .. en caso de cancelar, eliminamos el alertview y reactivamos botones y vistas.
                                                 [self enableButtons:YES];
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                    
                    [alert addAction:upload];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                } completed:^{
                    // En caso de completarse el array de señales de subidas de todas las imágenes con éxito, procedemos a la subida
                    // del producto
                    [self uploadProduct];
                }];
            } else {
                // ... El usuario ha decidido cancelar la subida del producto sin imágenes.
                [self enableButtons:YES];
            }
        }];
    // ... En caso de que alguno de los campos no esté completo
    } else {
        // ... mostramos error y reactivamos botones y vistas
        [self disableLoadingHUD];
        [self enableButtons:YES];
        UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:@"All fields are required" andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

/* 
 Método que convierte la subida del blob de la imagen en una señal. En caso de error obteniendo el SAS URL o durante la subida,
 devuelve el error. En caso de éxito, devuelve el completed
 */
-(RACSignal *) uploadPhoto: (UIImageView *) imageView {
    
    //UPLOAD IMAGE
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UIImage *img = imageView.image;
        self.manager = [[ABSManager alloc] init];
        
        User *user = [self.userM currentUser];
        NSString *now = [NSDate stringWithISO8601FormatDate:[NSDate new]];
        
        NSString *blobName = [NSString stringWithFormat:@"%@-%ld-%@",[user userId], (long)imageView.tag, now];
        NSMutableString *imageUrl = [[NSMutableString alloc] initWithString:AZURE_CDN_URL];
        [imageUrl appendString:AZURE_CONTAINER];
        [imageUrl appendString:@"/"];
        [imageUrl appendString:blobName];
        NSURL *imageNSURL = [NSURL URLWithString:imageUrl];
        NSLog(@"imageURL: %@", imageUrl);
        [self.temporaryImageNsurls addObject:imageNSURL];
        
        [self.manager giveMeSaSURLBlobName:blobName
                             containerName:AZURE_CONTAINER
                          completionSaSURL:^(NSURL *sasURL) {
                              if (sasURL != nil) {
                                  [self.manager handleImageToUploadAzureBlob:sasURL
                                                                     blobImg:img
                                                        completionUploadTask:^(BOOL result, NSError *error) {
                                                            if (error) {
                                                                [subscriber sendError:error];
                                                            } else {
                                                                [subscriber sendCompleted];
                                                            }
                                                        }];
                              } else {
                                  //NSLog(@"Error al obtener la SAS URL");
                                  [subscriber sendError:[NSError errorWithDomain:@"Azure SAS URL"
                                                                            code:400
                                                                        userInfo:nil]];
                              }
                          }];
        return 0;
    }] deliverOnMainThread];
}

/* 
 Método de subida del objeto producto. En caso de error muestra un alertview, y en caso de éxito, cerramos la vista
 y volvemos al listado de producto */
- (void)uploadProduct {
    if (!self.hud) {
        //dispatch_async(dispatch_get_main_queue(), ^{
        self.hud = [AppStyle getLoadingHUDWithView:self.view message:@"Uploading Product"];
        //});
    }
    
    self.product.name = self.lbTitle.text;
    self.product.detail = self.lbDescription.text;
    self.product.category = self.productCategory;
    self.product.price = self.lbPrice.text;
    
    self.product.images = [self.temporaryImageNsurls copy];
    
    NSDictionary *prod = [[Product alloc] objectToJSON:self.product];
    
    [self.api newProductViaProduct:prod
                           Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                               self.product.productId = [responseObject objectForKey:@"id"];
                               NSLog(@"Producto subido con éxito");
                               [self uploadProductImages];
                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [self enableButtons:YES];
                               [self disableLoadingHUD];
                               UIAlertController * alert = [[AlertUtil alloc] alertwithTitle:@"Error" andMessage:[error.userInfo valueForKey:@"NSLocalizedDescription"] andYesButtonTitle:@"" andNoButtonTitle:@"Cerrar"];
                               [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void) uploadProductImages {
    //TODO: Subida de imáges a la api de imágenes.
    NSLog(@"FALTA SUBIR IMÁGENES");
    self.temporaryImageNsurls = nil;
    [self disableLoadingHUD];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Botón de cancelar. Dismiss de la vista y vuelta al listado de productos.
- (IBAction)btAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) disableLoadingHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
        self.hud = nil;
    });
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
        // Bloqueamos la edición de la categoría. Solo se puede modificar mediante el picker.
        return NO;
    } else if (textField.tag == 3) {
        // Únicamente permitimos números en el campo de precio.
        NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterNoStyle];
        
        NSString * newString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        NSNumber * number = [nf numberFromString:newString];
        
        if (!number)
            return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Controlamos que no se pueda escribir más de los carácteres permitidos en el campo description.
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
    // Cada vez que modificamos el campo description, actualizamos el valor de la label que contiene los caracteres escritos.
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
    
    while ([imageData length] > 75000 && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(img, compression);
    }
    
    // Obtenemos el imageView al que hemos presionado para obtener la foto y le almacenamos la imagen.
    UIImageView *actualPhoto = [self getImageWithTag:self.imageSelectedTag];
    actualPhoto.image = [UIImage imageWithData:imageData];
    
    // Añadimos el tag de la imagen al array de tags de imageviews que contienen imágenes.
    [self.images addObject:@(actualPhoto.tag)];
    
    // Obtenemos el siguiente imageView y lo mostramos.
    UIImageView *nextPhoto = [self getImageWithTag:self.imageSelectedTag+1];
    nextPhoto.hidden = NO;

    // Quito de encima el controlador que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UIImageView Utils

// Método que escala una imagen al tamaño pasado por parámetro.
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

// Método que devuelve el imageView con el tag pasado por parámetro
-(UIImageView *) getImageWithTag:(NSInteger) tag {
    
    switch (tag) {
        case 5: return self.imgProduct1; break;
        case 6: return self.imgProduct2; break;
        case 7: return self.imgProduct3; break;
        default: return self.imgProduct4; break;
    }
}

#pragma mark - Photo methods

/*
 Método que comprueba si el imageView seleccionado ya contenía una foto o no. En caso de contenerla, le preguntamos
 al usuario si quiere cambiarla o eliminarla. En caso de ser un imageView vacío continuamos con la captura de la imagen.
 */
-(void) checkRemoveImage: (UIImageView *) imageView {
    self.imageSelectedTag = imageView.tag;
    
    // Si la imagen ya ha sido añadida con anterioridad
    if ([self.images containsObject:@(self.imageSelectedTag)]) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Product photo"
                                      message:@"What do you want to do with this picture?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* replace = [UIAlertAction
                                 actionWithTitle:@"Replace"
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
        
        [alert addAction:replace];
        [alert addAction:remove];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self tapAddPhoto:imageView];
    }
}

//Método que elimina la foto del imageView pasado por parámetro.
-(void) removePhoto:(UIImageView *) imageView {
    
    NSUInteger actualImagesCount = [self.images count];
    int imageToRemoveIndex = (int)[self.images indexOfObject:@(imageView.tag)];
    
    // Para todas las imágenes desde la seleccionada hasta la última
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
            if (actualImageView.tag != lastImageView.tag) {
                lastImageView.hidden = YES;
            }
        }
    }
    // Eliminamos el último tag del array de tags de imágenes del usuario
    [self.images removeLastObject];
}

// Método que captura una imagen mediante UIImagePickerController para el imageView pasado por parámetro
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
    [self presentViewController:picker animated:YES completion:nil];
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
    // Establecemos el product category y el nombre de la categoría en el textfield.
    self.productCategory = [self.categories objectAtIndex:row];
    self.lbCategory.text = [[self.categories objectAtIndex:row] name];
    [self.lbCategory resignFirstResponder];
}

#pragma mark - Utils

- (BOOL) hasNeededInformation {
    // Si alguno de los campos no está completo, devolvemos NO.
    if ([self isTextFieldEmpty:self.lbTitle] || [self isTextViewEmpty:self.lbDescription]
        || [self isTextFieldEmpty:self.lbCategory] || [self isTextFieldEmpty:self.lbPrice]) {
        return NO;
    }
    return YES;
}

/*
 Método que convierte en una señal el resultado de un uialertcontroller. En caso de que no existan imágenes del usuario
 le preguntamos si quiere subir el producto sin imágenes (devolviendo YES) o cancelar la subida (devolviendo NO). En 
 caso de existir imágnes, continuamos con la ejecución (devolviendo YES).
 */
- (RACSignal *) hasPhotosToUpload {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([self.images count]==0) {
            //NSLog(@"Preguntamos si queremos subir el producto sin imágenes");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Product without images"
                                          message:@"Want to upload the product without photos?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* upload = [UIAlertAction
                                     actionWithTitle:@"Yes"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [subscriber sendNext:@(YES)];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [subscriber sendNext:@(NO)];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            
            [alert addAction:upload];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [subscriber sendNext:@(YES)];
        }
        return 0;
    }] deliverOnMainThread];
}

// Método que activa o desactiva botones y vistas según el parámetro recibido.
- (void) enableButtons:(BOOL) enable {
    [self.btSellIt setEnabled:enable];
    [self.btCancel setEnabled:enable];
    [self.view setUserInteractionEnabled:enable];
    if (!enable) {
        [self.btSellIt setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [self.btSellIt setBackgroundColor:[AppStyle mainColorDark]];
    }
}

// Método que comprueba si un textfield está vacío o no.
- (BOOL)isTextFieldEmpty:(UITextField*)textField {
    if (textField.text && textField.text.length > 0)
        return NO;
    else
        return YES;
}

// Método que comprueba si un textView está vacío o no.
- (BOOL) isTextViewEmpty:(UITextView*)textView {
    if (textView.text && textView.text.length > 0)
        return NO;
    else
        return YES;
}

@end
