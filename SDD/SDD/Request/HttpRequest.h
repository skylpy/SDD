//
//  HttpRequest.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject
+ (void)postWithBaseURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)postWithMobileURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)postWithNewIssueURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)postWithMyIssueURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)postWithNewIssueSavaURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)postWithCommitSavaURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure;

+ (void)getWithMainShopURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)getWithShopCircleURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)getWithPositionURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)getWithFomatAeraURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)getWithProTypeURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)getWithIndustyURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;
+ (void)getWithNetureURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure;

@end
