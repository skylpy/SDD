//
//  GlobalController.h
//  SDD
//
//  Created by Cola on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalController : NSObject

+ (void)checkStatus;
+ (BOOL)isLogin;
+ (void)setLoginStatus:(BOOL)isLogin;

@end
