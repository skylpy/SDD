//
//  HttpRequest.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HttpRequest.h"
#import "Header.h"

@implementation HttpRequest
//开发商列表请求
+ (void)postWithBaseURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure
{
///house/developerList.do
   SDD_AFNetRequest
    //删除Json返回的<null>值，注意：会把整个键值删除
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
}
//手机验证  /sms/user/sendHouseApproveCode.do
+ (void)postWithMobileURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
   SDD_AFNetRequest
    //删除Json返回的<null>值，注意：会把整个键值删除
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];

}
//新项目发布
+ (void)postWithNewIssueURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    //删除Json返回的<null>值，注意：会把整个键值删除
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
    
}
//新项目保存
+ (void)postWithNewIssueSavaURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    //删除Json返回的<null>值，注意：会把整个键值删除
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
}

+ (void)postWithMyIssueURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    //删除Json返回的<null>值，注意：会把整个键值删除
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
}
//发展商认证提交
+ (void)postWithCommitSavaURL:(NSString *)baseURL path:(NSString *)path parameter:(NSDictionary *)params success:(void (^) (id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    //删除Json返回的<null>值，注意：会把整个键值删除
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];

}
//主力店列表
+ (void)getWithMainShopURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}
//项目圈列表
+ (void)getWithShopCircleURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}
//职务列表
+ (void)getWithPositionURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}
//业态面积
+ (void)getWithFomatAeraURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}
//项目类别
+ (void)getWithProTypeURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}
//行业列表
+ (void)getWithIndustyURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
    
}
//项目性质
+ (void)getWithNetureURL:(NSString *)baseURL path:(NSString *)path success:(void (^)(id Josn))success failure:(void (^)(NSError *error))failure
{
    SDD_AFNetRequest
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}
@end
