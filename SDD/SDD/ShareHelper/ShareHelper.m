//
//  ShareHelper.m
//  SDD
//
//  Created by mac on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ShareHelper.h"

static NSTimer *shareTime;


@implementation ShareHelper

+(void)shareIn:(UIViewController *)viewController content:(NSString *)content url:(NSString *)url image:(NSString *)imageUrl title:(NSString *)title
{
    NSLog(@"%@-----%@-----%@",url,imageUrl,title);
    //NSString * contStr = [NSString stringWithFormat:@"%@ %@",content,url];
    //构造分享内容SSPublishContentMediaTypeText
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithUrl:imageUrl]  //[ShareSDK imageWithPath:imageUrl]
                                                title:title
                                                  url:url
                                          description:@"商多多"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewController];
    
    NSArray *shareList = nil;
    shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQSpace,ShareTypeSinaWeibo, nil];//ShareTypeSinaWeibo
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    
                                    [self deleteAuth];
                                }
                            }];
}

//+ (void)shareIn:(UIViewController *)viewController content:(NSString *)content url:(NSString *)url image:(NSString *)imageUrl
//{
//    NSLog(@"%@-----%@",url,imageUrl);
//    //NSString * contStr = [NSString stringWithFormat:@"%@ %@",content,url];
//    //构造分享内容SSPublishContentMediaTypeText
//    id<ISSContent> publishContent = [ShareSDK content:content
//                                       defaultContent:@"测试一下"
//                                                image:[ShareSDK imageWithUrl:imageUrl]  //[ShareSDK imageWithPath:imageUrl]
//                                                title:@"543545dfs"
//                                                  url:url
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPhoneContainerWithViewController:viewController];
//    
//    NSArray *shareList = nil;
//    shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQSpace,ShareTypeSinaWeibo, nil];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                    
//                                    [self deleteAuth];
//                                }
//                            }];
//}

+ (void)shareIn:(UIViewController *)viewController content:(NSString *)content url:(NSString *)url
{
    
    NSLog(@"%@",url);
    //NSString * contStr = [NSString stringWithFormat:@"%@ %@",content,url];
    //构造分享内容SSPublishContentMediaTypeText   
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:nil]
                                                title:content      //@"ShareSDK"
                                                  url:url
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:viewController];
    
    NSArray *shareList = nil;
    shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQSpace, nil];//ShareTypeSinaWeibo
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    
                                    [self deleteAuth];
                                }
                            }];

}

+ (void)deleteAuth
{
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//    [ShareSDK cancelAuthWithType:ShareTypeTencentWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiTimeline];
}

+ (void)setupShareSdk
{
//    [ShareSDK connectSinaWeiboWithAppKey:@"2547447664"
//                               appSecret:@"8e51777509bf9983e34a3df2aa0bc303"
//                             redirectUri:@"http://www.shangdodo.com"
//                             weiboSDKCls:nil];
    
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"
//                                   wbApiCls:[WeiboApi class]];
    
     //微博
    [ShareSDK connectSinaWeiboWithAppKey:@"2547447664"
                               appSecret:@"8e51777509bf9983e34a3df2aa0bc303"
                             redirectUri:@"http://www.shangdodo.com"];
#pragma mark -- 网上的demo，可以分享了
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    //微信
    [ShareSDK connectWeChatWithAppId:@"wxf61e809509c45b58"
                           appSecret:@"e248328472f370ffb79397259bb277cd"
                           wechatCls:[WXApi class]];
    
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //[ShareSDK connectSMS];
    
    [self deleteAuth];
}

@end
