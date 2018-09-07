//
//  HousePreferential.h
//  SDD
//  获取优惠
//  Created by hua on 15/6/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HousePreferential : UIView

// logo内内容
@property (nonatomic, strong) UILabel *appVIP;
// 优惠内容
@property (nonatomic, strong) UILabel *appDiscount;
// 截止时间
@property (nonatomic, strong) UILabel *remainTime;
// 剩余面积
@property (nonatomic, strong) UILabel *remainArea;
// 已登记人数
@property (nonatomic, strong) UILabel *joined;
// 获取优惠
@property (nonatomic, strong) UIButton *getDiscount;

@property (nonatomic, strong)UIImageView *arrowImgView;
@end
