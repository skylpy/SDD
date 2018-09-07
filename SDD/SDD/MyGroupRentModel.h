//
//  MyGroupRentModel.h
//  SDD
//
//  Created by hua on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGroupRentModel : NSObject

//
@property (nonatomic, strong) NSString *mgr_addTime;
// 评价得分
@property (nonatomic, strong) NSString *mgr_commentScore;
//
@property (nonatomic, strong) NSString *mgr_houseId;
//
@property (nonatomic, strong) NSString *mgr_houseName;
// 是否评价
@property (nonatomic, strong) NSString *mgr_isCommented;
// 删除
@property (nonatomic, strong) NSString *mgr_isDelete;
// 是否支付
@property (nonatomic, strong) NSString *mgr_isPay;
// 订单id
@property (nonatomic, strong) NSString *mgr_orderId;
// 订单号
@property (nonatomic, strong) NSString *mgr_orderNumber;
// 流水号
@property (nonatomic, strong) NSString *mgr_paySn;
// 支付时间
@property (nonatomic, strong) NSString *mgr_payTime;
// 支付类型
@property (nonatomic, strong) NSString *mgr_payType;
// 电话号码
@property (nonatomic, strong) NSString *mgr_phone;
//
@property (nonatomic, strong) NSString *mgr_realName;
//
@property (nonatomic, strong) NSArray *mgr_specs;
//
@property (nonatomic, strong) NSString *mgr_totalPrice;
//
@property (nonatomic, strong) NSString *mgr_userId;
// 图片
@property (nonatomic, strong) NSString *mgr_defaultImage;


/*- 活动 -*/

// 活动id
@property (nonatomic, strong) NSString *mgr_activityId;
// 栋
@property (nonatomic, strong) NSString *mgr_buildingName;
// 层
@property (nonatomic, strong) NSString *mgr_floorName;
// 单元
@property (nonatomic, strong) NSString *mgr_unitName;

@end
