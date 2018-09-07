//
//  HttpTool.m
//  oniontrip
//
//  Created by Mac on 15-3-4.
//  Copyright (c) 2015年 LVTU. All rights reserved.
//
/*
    封装AFNetworking
    使用类方法直接使用
 */

#import "HttpTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface HttpTool()

@end

@implementation HttpTool

#pragma mark -- 上传图片
+ (void)uploadWithBaseURL:(NSString *)baseURL
                     Path:(NSString *)path
                   params:(NSDictionary *)params
                 dataName:(NSString *)dataName
               AlbumImage:(UIImage *)image
                  success:(void (^)(id responseObject))success
                     fail:(void (^)())fail{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *data = UIImageJPEGRepresentation(image,0.01);
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", dateStr];
        
        [formData appendPartWithFileData:data name:dataName fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];            
            
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"err:%@",[error description]);
        if (fail) {
            fail();
        }
    }];
}

#pragma mark -- POST
+ (void)postWithBaseURL:(NSString *)baseURL
                   Path:(NSString *)path
                 params:(NSDictionary *)params
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,path];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //删除Json返回的<null>值，注意：会把整个键值删除
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
              if (success) {
                  success(responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure == nil) return;
              failure(error);
          }];
}

#pragma mark -- GET
+ (void)getWithBaseURL:(NSString *)baseURL
                  Path:(NSString *)path
               success:(HttpSuccessBlock)success
               failure:(HttpFailureBlock)failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",baseURL,path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    // 防止解析不出来
    manager.responseSerializer.acceptableContentTypes = \
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    [manager GET:urlStr
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure == nil) return;
             failure(error);
         }];
    
}

@end
