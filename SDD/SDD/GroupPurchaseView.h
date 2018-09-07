//
//  GroupPurchaseView.h
//  SDD
//  看房团里的房屋简介 跟cell结构一样
//  Created by hua on 15/4/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPurchaseView : UIView

// 图片
@property (nonatomic, strong) UIImageView *placeImage;
// 地名
@property (nonatomic, strong) UILabel *placeTitle;
// 地址
@property (nonatomic, strong) UILabel *placeAdd;
// 抵价
@property (nonatomic, strong) UILabel *placeDiscount;
// 价格
@property (nonatomic, strong) UILabel *placePrice;
// 团购剩余时间
@property (nonatomic, strong) UILabel *placeRemainingTime;

@end
