//
//  CounselorInfoView.h
//  SDD
//
//  Created by hua on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"

@interface CounselorInfoView : UIView

// 评分标题
@property (nonatomic, strong) UILabel *gradeTitle;
// 得分
@property (nonatomic, strong) UILabel *gradePercent;
// 进度条
@property (nonatomic, strong) LDProgressView *gradeProgress;
// 条数统计
@property (nonatomic, strong) UILabel *gradeCounts;


@end
