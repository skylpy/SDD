//
//  JoinIndexTableViewCell.h
//  SDD
//  加盟商列表cell
//  Created by hua on 15/6/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface JoinIndexTableViewCell : UITableViewCell

// 加盟商图片
@property (nonatomic, strong) UIImageView *franchiseesImage;

// 加盟商优惠
@property (nonatomic, strong) UIImageView *franchiseesLogo;

// 加盟商logo
@property (nonatomic, strong) UIImageView *preferentialLogo;
// 加盟商名
@property (nonatomic, strong) TTTAttributedLabel *franchiseesName;
// 推荐
@property (nonatomic, strong) UILabel *recommand;
// 投资额度
@property (nonatomic, strong) TTTAttributedLabel *investmentAmounts;
// 所属行业
@property (nonatomic, strong) TTTAttributedLabel *industry;
// 门店数量
@property (nonatomic, strong) TTTAttributedLabel *franchiseesAmounts;
// 是否推荐品牌
@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, strong)UILabel * franchiseesAmounts_unit;

@end
