//
//  GroupRentNewViewController.h
//  SDD
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface GroupRentNewViewController : XHBaseViewController

@property (assign,nonatomic) NSInteger activityCategoryId;
@property (assign,nonatomic) NSInteger regionId;


// 类型 0:详情进入 1:首页进入 2: 加盟商进入
@property (nonatomic, assign) NSInteger fromIndex;


// 品牌id
@property (nonatomic, strong) NSString *brankId;
// 当前省份
@property (nonatomic, strong) NSString *currentProvince;
// 当前省份id
@property (nonatomic, strong) NSString *currentProvinceId;
// 当前城市
@property (nonatomic, strong) NSString *currentCity;
// 经度
@property (nonatomic, assign) float theLongitude;
// 纬度
@property (nonatomic, assign) float theLatitude;

//入的类型
@property (nonatomic, assign) NSInteger enterType;

@end
