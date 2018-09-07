//
//  HouseResourcesModel.h
//  SDD
//
//  Created by hua on 15/4/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseResourcesModel : NSObject

// 地址
@property (nonatomic, copy) NSString *hr_address;
// 默认图片
@property (nonatomic, copy) NSString *hr_defaultImage;
// 发展id
@property (nonatomic, copy) NSString *hr_developersId;

// 房id
@property (nonatomic, copy) NSString *hr_houseId;
// 房名
@property (nonatomic, copy) NSString *hr_houseName;
// 内容
@property (nonatomic, copy) NSString *hr_perferentialContent;
// 内容
@property (nonatomic, copy) NSString *hr_rentPreferentialContent;
// 结束时间
@property (nonatomic, copy) NSString *hr_preferentialEndtime;
// 价格
@property (nonatomic, copy) NSString *hr_price;
// 电话
@property (nonatomic, copy) NSString *hr_tel;
// 纬度
@property (nonatomic, copy) NSString *hr_latitude;
// 经度
@property (nonatomic, copy) NSString *hr_longitude;
// 类型
@property (nonatomic, copy) NSString *hr_activityCategoryId;
// 租金参考价
@property (nonatomic, copy) NSString *hr_rentPrice;
// 团购价 （未用）
@property (nonatomic, copy) NSString *hr_buyPrice;
// 招商对象
@property (nonatomic, copy) NSString *hr_planFormat;
// 是否特价铺
@property (nonatomic, copy) NSString *hr_isActivityHouse;
// 状态
@property (nonatomic, copy) NSString *hr_merchantsStatus;
// 建筑面积
@property (nonatomic, copy) NSString *hr_buildingArea;

// 加盟id
@property (nonatomic, copy) NSString *hr_brandId;
// 加盟商名
@property (nonatomic, copy) NSString *hr_brandName;
// 投资额度
@property (nonatomic, copy) NSString *hr_totalInvestmentAmount;
// 行业
@property (nonatomic, copy) NSString *hr_industryCategoryName;
// 门店数量
@property (nonatomic, copy) NSString *hr_storeAmount;

// 动态图片
@property (nonatomic, copy) NSString *hr_icon;
// 动态名
@property (nonatomic, copy) NSString *hr_title;
// 动态简介
@property (nonatomic, copy) NSString *hr_summary;
// 动态id
@property (nonatomic, copy) NSString *hr_dynamicId;
//品牌类型
@property (nonatomic, copy) NSString *hr_type;

+ (instancetype)hrWithDict:(NSDictionary *)dict;

@end
