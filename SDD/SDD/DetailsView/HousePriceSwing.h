//
//  HousePriceSwing.h
//  SDD
//  房价走势
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HousePriceSwing : UIView

// 走势
@property (nonatomic, strong) UIScrollView *movements_bg;
// 走势城市
@property (nonatomic, strong) UILabel *movementCity;

@end
