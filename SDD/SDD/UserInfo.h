//
//  UserInfo.h
//  SDD
//  用户信息单例储存
//  Created by hua on 15/7/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

// 用户信息
@property (nonatomic, strong) NSDictionary *userInfoDic;

+ (UserInfo *)sharedInstance;

@end
