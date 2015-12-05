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

- (void)startReachabilityMonitor;
- (void)stopReachabilityMonitor;

// login *****
- (NSURLSessionDataTask *)logInViaEmail:(NSString *)userEmail
                            andPassword:(NSString *)userPassword
                                Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

// products 
- (NSURLSessionDataTask *)productsViaCategory:(NSString *)category
                                  andDistance:(NSString *)distance
                                      andWord:(NSString *) word
                                      Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
