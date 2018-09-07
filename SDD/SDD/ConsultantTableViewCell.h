//
//  ConsultantTableViewCell.h
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface ConsultantTableViewCell : UITableViewCell

// 用户头像
@property (nonatomic, strong) UIImageView *avatar;
// 用户昵称
@property (nonatomic, strong) UILabel *nickname;
// 评分
@property (nonatomic, strong) CWStarRateView *starRate;
// 评论
@property (nonatomic, strong) UILabel *comment;
// 打电话
@property (nonatomic, strong) UIButton *makeCall;
// 在线咨询
@property (nonatomic, strong) UIButton *makeContact;

@end
