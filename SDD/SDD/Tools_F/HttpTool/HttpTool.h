//
//  HttpTool.h
//  oniontrip
//
//  Created by Mac on 15-3-4.
//  Copyright (c) 2015年 LVTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject
//get,post block使用
typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

// post
+ (void)postWithBaseURL:(NSString *)baseURL
                   Path:(NSString *)path
                 params:(NSDictionary *)params
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;
// get
+ (void)getWithBaseURL:(NSString *)baseURL
                  Path:(NSString *)path
               success:(HttpSuccessBlock)success
               failure:(HttpFailureBlock)failure;
// 上传图片
+ (void)uploadWithBaseURL:(NSString *)baseURL
                     Path:(NSString *)path
                   params:(NSDictionary *)params
                 dataName:(NSString *)dataName
               AlbumImage:(UIImage *)image
                  success:(void (^)(id responseObject))success
                     fail:(void (^)())fail;


@end
