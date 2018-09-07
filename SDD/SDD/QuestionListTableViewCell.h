//
//  QuestionListTableViewCell.h
//  SDD
//  问题列表
//  Created by hua on 15/7/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionListTableViewCell : UITableViewCell

// 问题
@property (nonatomic, strong) UILabel *theQuestion;
// 答案背景
@property (nonatomic, strong) UIView *answer_bg;
// 答案
@property (nonatomic, strong) UILabel *theAnswer;
// 标签
@property (nonatomic, strong) UILabel *theTags;
// 回答数
@property (nonatomic, strong) UIButton *theAnswerQty;
// 是否有最佳
@property (nonatomic, assign) BOOL haveBestAnswer;

@end
