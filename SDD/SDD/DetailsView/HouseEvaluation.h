//
//  HouseEvaluation.h
//  SDD
//  在线评房
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface HouseEvaluation : UIView

// 在线评房
@property (nonatomic, strong) UITableView *evaluationTable;
// 星星
@property (nonatomic, strong) CWStarRateView *totalStar;
// 得分
@property (nonatomic, strong) UILabel *totalScore;
// 得分详情
@property (nonatomic, strong) UILabel *scoreDetail;
// 评房点评
@property (nonatomic, strong) ConfirmButton *evaluationButton;

@end
