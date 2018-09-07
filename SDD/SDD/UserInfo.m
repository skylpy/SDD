//
//  UserInfo.m
//  SDD
//
//  Created by hua on 15/7/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)sharedInstance{
    
    // 设nil
    static UserInfo *_sharedInstance = nil;
    // 只执行一次
    static dispatch_once_t oncePredicate;
    // 初始化
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UserInfo alloc] init];
    });
    return _sharedInstance;
}


@end
