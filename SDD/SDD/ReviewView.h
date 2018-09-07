//
//  ReviewView.h
//  SDD
//  评分视图
//  Created by hua on 15/4/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface ReviewView : UIView

// 评分标题
@property (nonatomic, strong) UILabel *starTitle;
// 评分
@property (nonatomic, strong) CWStarRateView *starRate;
// 得分
@property (nonatomic, strong) UILabel *score;

@end
