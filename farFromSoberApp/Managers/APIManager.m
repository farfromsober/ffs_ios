//
//  APIManager.m
//  farFromSoberApp
//
//  Created by David Regatos on 21/11/15.
//  Copyright © 2015 David Regatos. All rights reserved.
//

#import "APIManager.h"
#import "UserManager.h"
#import "AppConstants.h"

@interface APIManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (weak, nonatomic) AFNetworkReachabilityManager *reachabilityManager;

@property (strong, nonatomic) AFJSONResponseSerializer *jsonResponseSerializer;
@property (strong, nonatomic) AFJSONRequestSerializer *jsonRequestSerializer;

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appKey;

@property (nonatomic, copy) NSArray *distances;

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
    // Almacenamos el auth header en el nsuserdefaults.
    NSString * authHeaderValue = [_jsonRequestSerializer valueForHTTPHeaderField:@"Authorization"];
    [[NSUserDefaults standardUserDefaults] setObject:authHeaderValue forKey:[AppConstants authHeaderKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        // Si el usuario ya está logeado recuperamos el auth header del nsuserdefaults.
        if ([[UserManager sharedInstance] currentUser]) {
            NSString *authHeaderValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:[AppConstants authHeaderKey]];
            [shared.sessionManager.requestSerializer setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
        }
        
        // FIXME
        shared.distances = @[@100, @50, @10, @5, @1];
        
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
                                success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
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
- (NSURLSessionDataTask *)fetchProductsWithCategory:(NSString *)category
                                           distance:(NSString *)distance
                                         andKeyword:(NSString *) word
                                success:(void (^)(NSURLSessionDataTask *task, NSArray *responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *parameters;
    if ([distance compare:@""] != 0) {
        distance = self.distances[[distance integerValue]];
        parameters = @{@"category":category,
                       @"name":word,
                       @"distance":distance,
                       @"longitude":[[UserManager sharedInstance] currentUser].longitude,
                       @"latitude":[[UserManager sharedInstance] currentUser].latitude
                      };
    } else {
        parameters = @{@"category":category, @"name":word};
    }
    
    return [[self sessionManager] GET:@"/api/1.0/products/?selling=2"
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
                                   success(task, responseObject);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   failure(task, error);
                               }];
}

- (NSURLSessionDataTask *)productsForUser:(NSString *)username
                                  selling:(BOOL )selling
                                  Success:(void (^)(NSURLSessionDataTask *task, NSArray *responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *parameters = @{@"seller":username, @"selling":selling?@"2":@"3"};
    
    return [[self sessionManager] GET:@"/api/1.0/products/"
                           parameters:parameters
                              success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
                                  success(task, responseObject);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  failure(task, error);
                              }];
}

- (NSURLSessionDataTask *)productsBoughtSuccess:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    return [[self sessionManager] GET:@"/api/1.0/products-bought/"
                           parameters:nil
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

- (NSURLSessionDataTask *)newImages:(NSArray *)images
                         ViaProductId:(NSString *)productId
                            Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:productId forKey:@"productId"];
    [parameters setObject:images forKey:@"urls"];
    
    
    return [[self sessionManager] POST:@"/api/1.0/images/"
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                   success(task, responseObject);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   failure(task, error);
                               }];
}

#pragma mark - User data request
- (NSURLSessionDataTask *)userDataById:(int)userId
                               Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    return [[self sessionManager] GET:[NSString stringWithFormat:@"/api/1.0/users/%d", userId]
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                  success(task, responseObject);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  failure(task, error);
                              }];
}

#pragma mark - Buy products

- (NSURLSessionDataTask *)buyProductWithId:(NSString *)productId
                            Success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:productId forKey:@"productId"];
    NSString *userId = [NSString stringWithFormat:@"%@", [[UserManager sharedInstance] currentUser].userId];
    [parameters setObject:userId forKey:@"buyerId"];
    
    
    return [[self sessionManager] POST:@"/api/1.0/transactions/"
                            parameters:parameters
                               success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                   success(task, responseObject);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   failure(task, error);
                               }];
}

#pragma mark - Utils

- (NSString *) filePath {
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:[AppConstants userStoragePath]];
    }
    return filePath;
}


@end
