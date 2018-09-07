//
//  MapViewController.h
//  SDD
//  地图
//  Created by hua on 15/4/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MapViewController : XHBaseViewController

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

@end
