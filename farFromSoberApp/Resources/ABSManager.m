//
//  ABSManager.m
//  AzureExample
//
//  Created by Joan on 18/11/15.
//  Copyright © 2015 biscarri. All rights reserved.
//

#import "ABSManager.h"
#import "AzureDefines.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface ABSManager()

@property (nonatomic, strong) MSClient *client;

@end

@implementation ABSManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [MSClient clientWithApplicationURLString:AZURE_END_POINT
                                            applicationKey:AZURE_APP_KEY];
    }
    return self;
}

/** Get SAS image URL (Shared Access Signatures)
@param blobName Image name (with extension)
@param containerName Name of Azure containe
@param completion block that receives SAS url from Azure
*/
- (void)giveMeSaSURLBlobName:(NSString *)blobName
               containerName:(NSString*)containerName
            completionSaSURL:(void (^)(NSURL *sasURL))completion {
    
    NSDictionary *parameters = @{@"blobName" : blobName, @"containerName" : containerName};
    NSDictionary *headers = @{@"Content-type" : @"Application/json"};
    [self.client invokeAPI:AZURE_SAS_API body:nil HTTPMethod:@"GET" parameters:parameters headers:headers completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        if (error != nil)
            completion(nil);
        else {
            if (result[@"sasUrl"] != nil) {
                NSURL *sasURL = [NSURL URLWithString:result[@"sasUrl"]];
                completion(sasURL);
            } else {
                completion(nil);
            }
        }
    }];
}

/** Download URL
 @param theURL Image URL
 @param completion receives image or error
 */
- (void)handleSaSURLToDownload:(NSURL *)theURL
           completionHandleSaS:(void (^)(UIImage *image, NSError *error))completion {
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:theURL];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            completion(image, error);
        }
        
    }];
    [downloadTask resume];
}

/** Upload URL
 @param theURL Image URL (SAS)
 @param blobImg UIImage to upload
 @param completion receives result (BOOL) or error
 */
- (void)handleImageToUploadAzureBlob:(NSURL *)theURL
                             blobImg:(UIImage*)blobImg
                completionUploadTask:(void (^)(BOOL result, NSError * error))completion {
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:theURL];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = UIImageJPEGRepresentation(blobImg, 1.f);
    
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSLog(@"resultado --> %@", response);
            completion(YES, nil);
        } else {
            completion(NO, error);
        }
        
    }];
    [uploadTask resume];
}

/** GET CDN URL from blob name
 @param blobName Image name (with extension)
 */
+ (NSString*)getCDNURLStringForblobName:(NSString *)blobName {
    return [NSString stringWithFormat:@"%@%@/%@", AZURE_CDN_URL, AZURE_CONTAINER, blobName];
}



@end
