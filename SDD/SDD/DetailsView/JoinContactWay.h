//
//  JoinContactWay.h
//  SDD
//  加盟详情页 - 联系方式
//  Created by hua on 15/6/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinContactWay : UIView

// 名
@property (nonatomic, strong) UILabel *peopleName;
// 职位
@property (nonatomic, strong) UILabel *peoplePosition;
// 地方
@property (nonatomic, strong) UILabel *peopleRegion;
// 固话
@property (nonatomic, strong) UILabel *peopleTel;
// 手机号
@property (nonatomic, strong) UILabel *peopleMobileNum;
// 邮箱
@property (nonatomic, strong) UILabel *peopleEmail;
// 地址
@property (nonatomic, strong) UILabel *peopleAddress;

@end
