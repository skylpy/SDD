//
//  ActivityTableViewCell.h
//  SDD
//
//  Created by hua on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

// 图片
@property (nonatomic, strong) UIImageView *placeImage;
// 团购图片
@property (nonatomic, strong) UIImageView *teamImg;
// 地名
@property (nonatomic, strong) UILabel *placeTitle;
// 副标题
@property (nonatomic, strong) UILabel *placeSubtitle;
// 时间
@property (nonatomic, strong) UILabel *placeTime;
// 人数
@property (nonatomic, strong) UILabel *placePeople;
// 地点
@property (nonatomic, strong) UILabel *placeAdd;
// 已报名
@property (nonatomic, strong) UILabel *joined;
// 右下按钮
@property (nonatomic, strong) UIButton *joinButton;

@end
