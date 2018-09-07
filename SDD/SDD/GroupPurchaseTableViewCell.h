//
//  GroupPurchaseTableViewCell.h
//  sdd_iOS_personal
//  团购 团租 房源tableviewcell
//  Created by hua on 15/4/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPurchaseTableViewCell : UITableViewCell

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

@property (nonatomic, strong) UIButton *placePriBtn;

@property (nonatomic, strong) UILabel *rentalLabel;

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

// 是否推荐品牌
@property (nonatomic, assign) BOOL isRecommend;

/* 用户类型 
 
    0：首页-团购
    1：首页-团租
    2：首页-品牌商
    3：咨询
 */
typedef NS_ENUM(NSInteger, CellType)
{
    index_gp = 0,
    index_gr = 1,
    index_hr = 2,
    index_dy = 3,
    index_gr_noPreferential = 4,
    personal_activities = 5,
    
    perchase_shop = 6
};
@property (nonatomic, assign) CellType cellType;

@end
