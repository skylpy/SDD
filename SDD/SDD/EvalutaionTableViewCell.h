//
//  EvalutaionTableViewCell.h
//  商多多
//  用户点评
//  Created by hua on 15/4/8.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#import "TTTAttributedLabel.h"

@interface EvalutaionTableViewCell : UITableViewCell

// 用户头像
@property (nonatomic, strong) UIImageView *avatar;
// 用户昵称
@property (nonatomic, strong) UILabel *nickname;
// 评分
@property (nonatomic, strong) CWStarRateView *starRate;
// 用户类型 (0普通 1小编)
@property (nonatomic, assign) int userType;
// 评论
@property (nonatomic, strong) TTTAttributedLabel *comment;
// 评论时间
@property (nonatomic, strong) UILabel *commentTime;

@end
