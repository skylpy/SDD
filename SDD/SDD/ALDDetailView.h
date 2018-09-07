//
//  ALDDetailView.h
//  SDD
//
//  Created by hua on 15/4/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALDDetailView : UIView

@property (nonatomic, strong) UIImageView *avatar;                    // 头像
@property (nonatomic, strong) UILabel *identity;                      // 身份
@property (nonatomic, strong) UILabel *name;                          // 姓名
@property (nonatomic, strong) UIButton *makeCall;                     // 打电话
@property (nonatomic, strong) UIButton *makeContact;                  // 咨询
@property (nonatomic, strong) UILabel *describe;                      // 描述

@end
