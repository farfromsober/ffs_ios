//
//  APIManager.h
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface APIManager : NSObject

@property (strong, nonatomic, readonly) AFHTTPSessionManager *sessionManager;
@property (weak, nonatomic, readonly) AFNetworkReachabilityManager *reachabilityManager;

+ (id)sharedManager;

- (void) setHeaderCredentials:(NSString *) username
                     password:(NSString *) password;

- (void)startReachabilityMonitor;
- (void)stopReachabilityMonitor;

// login *****
- (NSURLSessionDataTask *)logInViaEmail:(NSString *)userEmail
                            andPassword:(NSString *)userPassword
                                success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// products 
- (NSURLSessionDataTask *)fetchProductsWithCategory:(NSString *)category
                                  distance:(NSString *)distance
                                      andKeyword:(NSString *) word
                                      success:(void (^)(NSURLSessionDataTask *task, NSArray *responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)productsForUser:(NSString *)username
                                  selling:(BOOL )selling
                                  Success:(void (^)(NSURLSessionDataTask *task, NSArray *responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)productsBoughtSuccess:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)newProductViaProduct: (NSDictionary *) product
                                       Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)newImages:(NSArray *)images
                       ViaProductId:(NSString *)productId
                            Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//user
- (NSURLSessionDataTask *)userDataById:(int)userId
                               Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//transaction
- (NSURLSessionDataTask *)buyProductWithId:(NSString *)productId
                                   Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
