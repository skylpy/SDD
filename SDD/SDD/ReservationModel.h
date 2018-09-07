//
//  ReservationModel.h
//  SDD
//
//  Created by hua on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReservationModel : NSObject

// 栏目id
@property (nonatomic, strong) NSString *r_activityCategoryId;
// 增加时间
@property (nonatomic, strong) NSString *r_addTime;
// id
@property (nonatomic, strong) NSString *r_houseId;
// 房名
@property (nonatomic, strong) NSString *r_houseName;
// 图片
@property (nonatomic, strong) NSString *r_defaultImage;
// 经度
@property (nonatomic, strong) NSString *r_longitude;
// 纬度
@property (nonatomic, strong) NSString *r_latitude;
// 线路介绍
@property (nonatomic, strong) NSString *r_showingsLineIntroduction;
// 截止时间
@property (nonatomic, strong) NSString *r_showingsEndtime;
// 报名人数
@property (nonatomic, strong) NSString *r_applyPeopleQty;
// 最高优惠
@property (nonatomic, strong) NSString *r_showingsMaxPreferential;
// 价格
@property (nonatomic, strong) NSString *r_price;
//
//@property (nonatomic, strong) NSString *r_;

@end
