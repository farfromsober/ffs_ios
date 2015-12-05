//
//  ABSManager.h
//  AzureExample
//
//  Created by Joan on 18/11/15.
//  Copyright © 2015 biscarri. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ABSManager : NSObject

- (void)giveMeSaSURLBlobName:(NSString *)blobName
               containerName:(NSString*)containerName
            completionSaSURL:(void (^)(NSURL *sasURL))completion;

- (void)handleSaSURLToDownload:(NSURL *)theURL
           completionHandleSaS:(void (^)(UIImage *image, NSError *error))completion;

- (void)handleImageToUploadAzureBlob:(NSURL *)theURL
                             blobImg:(UIImage*)blobImg
                completionUploadTask:(void (^)(BOOL result, NSError * error))completion;

+ (NSString*)getCDNURLStringForblobName:(NSString *)blobName;

@end
