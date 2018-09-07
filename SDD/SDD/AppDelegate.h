//
//  AppDelegate.h
//  sdd_iOS_personal
//
//  Created by hua on 15/4/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MiPushSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MiPushSDKDelegate>{
    
    //环信链接状态
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property BOOL isLogin;

- (void)toMainView;

@end

