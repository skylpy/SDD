//
//  QuestionAndAnswerTableViewCell.h
//  SDD
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionAndAnswerTableViewCell : UITableViewCell

@property (retain,nonatomic)UIImageView * HeadImageView;//头像

@property (retain,nonatomic)UIImageView * coinImageView;//回答标志

@property (retain,nonatomic)UILabel * nameLabel;//用户名

@property (retain,nonatomic)UILabel * timeLabel;//时间

@property (retain,nonatomic)UILabel * comLabel;//内容

@property (retain,nonatomic)UILabel * numLabel;//回答数

@end
