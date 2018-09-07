//
//  ShareHelper.h
//  SDD
//
//  Created by mac on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

/*
    shareSDK 封装
 */
#import <Foundation/Foundation.h>

@interface ShareHelper : NSObject

+ (void)shareIn:(UIViewController *)viewController content:(NSString *)content url:(NSString *)url;

+ (void)setupShareSdk;

+ (void)deleteAuth;

//+ (void)shareIn:(UIViewController *)viewController content:(NSString *)content url:(NSString *)url image:(NSString *)imageUrl;

+ (void)shareIn:(UIViewController *)viewController content:(NSString *)content url:(NSString *)url image:(NSString *)imageUrl title:(NSString *)title;

@end
