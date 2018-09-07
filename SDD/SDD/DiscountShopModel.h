//
//  DiscountShopModel.h
//  SDD
//
//  Created by hua on 15/5/5.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountShopModel : NSObject

// 活动id
@property (nonatomic, copy) NSString *ds_activityId;
// 地址
@property (nonatomic, copy) NSString *ds_address;
// 建筑名
@property (nonatomic, copy) NSString *ds_buildingName;
// 默认图片
@property (nonatomic, copy) NSString *ds_defaultImage;
// 截止时间
@property (nonatomic, copy) NSString *ds_endTime;
// 层名
@property (nonatomic, copy) NSString *ds_floorName;
// 房名
@property (nonatomic, copy) NSString *ds_houseName;
// 房价
@property (nonatomic, copy) NSString *ds_housePrice;
// 房编制
@property (nonatomic, copy) NSString *ds_houseUnitId;
// 是否售出
@property (nonatomic, copy) NSString *ds_isPay;
// 号码
@property (nonatomic, copy) NSString *ds_tel;
// 单元名
@property (nonatomic, copy) NSString *ds_unitName;
// 房子ID
@property (nonatomic, copy) NSString *ds_houseId;
// 定金
@property (nonatomic, copy) NSString *ds_earnestMoney;
// 面积
@property (nonatomic, copy) NSString *ds_area;

@end
