//
//  MapListCell.h
//  SDD
//
//  Created by mac on 15/11/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapListCell : UITableViewCell

// 图片
@property (nonatomic, strong) UIImageView *placeImage;
// 团购图片
@property (nonatomic, strong) UIImageView *teamImg;
// 地名【第一行
@property (nonatomic, strong) UILabel *placeTitle;
// 地址【第二行
@property (nonatomic, strong) UILabel *placeAdd;
// 抵价【第三行
@property (nonatomic, strong) UILabel *placeDiscount;
// 价格【第四行
@property (nonatomic, strong) UILabel *placePrice;
// 上方按钮
@property (nonatomic, strong) UIButton *topButton;
// 下方按钮
@property (nonatomic, strong) UIButton *bottonButton;
// 特价铺图片(团购)
@property (nonatomic, strong) UIImageView *activityImg;
// 状态(我的-活动)
@property (nonatomic, strong) UIButton *statusLabel;
// 独享（团租）
@property (nonatomic, strong) UILabel *privateLabel;


@end
