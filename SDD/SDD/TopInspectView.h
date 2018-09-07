//
//  TopInspectView.h
//  SDD
//
//  Created by mac on 16/1/6.
//  Copyright (c) 2016年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopInspectView : UIView

@property (retain,nonatomic)UIImageView * topImage;//顶部照片
@property (retain,nonatomic)UILabel * SponsorLable;//主办单位
@property (retain,nonatomic)UILabel * AssistingLable;//协办单位
@property (retain,nonatomic)UILabel * ActivityTimeLable;//活动时间
@property (retain,nonatomic)UILabel * CollectionSiteLable;//集合地点

@property (retain,nonatomic)UIImageView * icondImage;//截止时间icon
@property (retain,nonatomic)UILabel * DeadlineLable;//截止时间

@property (retain,nonatomic)UIImageView * iconsImage;//已报名人数icon
@property (retain,nonatomic)UILabel * SignUpLable;//已报名人数

@end
