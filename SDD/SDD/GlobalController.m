//
//  GlobalController.m
//  SDD
//  全局属性
//  Created by Cola on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "GlobalController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "CommonCrypto/CommonDigest.h"


@interface GlobalController ()
@end

@implementation GlobalController

+ (void)checkStatus{
    
    // 先读取本地cookies
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    
    if (cookies) {
        
        for (NSHTTPCookie *cookie in cookies){
            
            NSLog(@"读取cookies成功");
            [self checkWeb];
            [cookieStorage setCookie:cookie];
            break;
        }
    }
    else {
        
        NSLog(@"读取cookies失败");

        [self checkWeb];
        //[self setLoginStatus:NO];
        // 注销环信
        //[[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
        //发送自动登陆状态通知
        //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

+ (void)checkWeb{
    
    // 再验证服务器上的登录状态（以防coookies过期或服务器重启引起的cookies失效）
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    //        httpManager.requestSerializer.timeoutInterval = 15;         //设置超时时间
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    // 请求参数
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/detail.do"];              // 拼接主路径和请求内容成完整url
    
    [httpManager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
//        NSLog(@"%@",dict);
        if ([dict[@"status"] intValue] == -2) {
            
            [self setLoginStatus:NO];
            // 注销环信
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            NSLog(@"未登录");
        }
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            // 用户信息
            [UserInfo sharedInstance].userInfoDic = dict[@"data"];
            
            [self setLoginStatus:YES];
            NSLog(@"已登录");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
}

+ (BOOL)isLogin
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    return delegate.isLogin;
}

+ (void)setLoginStatus:(BOOL)isLogin
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (isLogin) {
        NSLog(@"储存cookies");
        // saveCookies
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        [defaults setObject: cookiesData forKey:@"sessionCookies"];
        [defaults synchronize];
    }
    else {
        NSLog(@"移除cookies");
        // removeCookies
        [defaults removeObjectForKey:@"sessionCookies"];
    }
    
    delegate.isLogin = isLogin;
}

@end
