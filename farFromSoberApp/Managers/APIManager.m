//
//  APIManager.m
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "APIManager.h"
#import "UserManager.h"

@interface APIManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (weak, nonatomic) AFNetworkReachabilityManager *reachabilityManager;

@property (strong, nonatomic) AFJSONResponseSerializer *jsonResponseSerializer;
@property (strong, nonatomic) AFJSONRequestSerializer *jsonRequestSerializer;

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appKey;

@end

@implementation APIManager

static NSString *const serverBaseURL = @"http://forsale.cloudapp.net";

#pragma mark - accessors
- (NSString *)appID  {
    if  (!_appID) _appID = @"";
    return _appID;
}

- (NSString *)appKey  {
    if  (!_appKey) _appKey = @"";
    return _appKey;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers];
    }
    return _jsonResponseSerializer;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer  {
    if  (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _jsonRequestSerializer;
}

- (void) setHeaderCredentials:(NSString *) username
                     password:(NSString *) password {
    [_jsonRequestSerializer setAuthorizationHeaderFieldWithUsername:username
                                                           password:password];
}

#pragma mark - interface methods
+ (id)sharedManager {
    static dispatch_once_t onceToken;
    static APIManager *shared;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        shared.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:serverBaseURL]];
        shared.sessionManager.responseSerializer = [shared jsonResponseSerializer];
        shared.sessionManager.requestSerializer = [shared jsonRequestSerializer];
        shared.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    });
    
    return shared;
}

#pragma mark - reachability monitor
- (void)startReachabilityMonitor {
    [self.reachabilityManager startMonitoring];
}

- (void)stopReachabilityMonitor {
    [self.reachabilityManager stopMonitoring];
}

#pragma mark - Log In requests
- (NSURLSessionDataTask *)logInViaEmail:(NSString *)userEmail
                            andPassword:(NSString *)userPassword
                                Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *parameters = @{@"user":userEmail, @"password":userPassword};
    
    return [[self sessionManager] POST:@"/api/1.0/login/"
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                   success(task, responseObject);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   failure(task, error);
                               }];
}

#pragma mark - Products request
- (NSURLSessionDataTask *)productsViaCategory:(NSString *)category
                                  andDistance:(NSString *)distance
                                      andWord:(NSString *) word
                                Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *parameters = @{@"category":category, @"distance":distance, @"word":word};
    
    return [[self sessionManager] GET:@"/api/1.0/products/"
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                   success(task, responseObject);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   failure(task, error);
                               }];
}

- (NSURLSessionDataTask *)newProductViaProduct: (NSDictionary *) product
                                      Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    return [[self sessionManager] POST:@"/api/1.0/products/"
                           parameters:product
                              success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                  success(task, responseObject);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  failure(task, error);
                              }];
}

@end
