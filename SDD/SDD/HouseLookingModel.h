//
//  HouseLookingModel.h
//  SDD
//  看房团模型
//  Created by hua on 15/4/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseLookingModel : NSObject

// 房子属性
@property (nonatomic, strong) NSDictionary *hk_house;
// 报名人数
@property (nonatomic, strong) NSString *hk_applyPeopleQty;
// 活动id
@property (nonatomic, strong) NSString *hk_activityCategoryId;
// 房子id
@property (nonatomic, strong) NSString *hk_houseId;
// 活动内容
@property (nonatomic, strong) NSString *hk_perferentialContent;
// 价格
@property (nonatomic, strong) NSString *hk_price;
// 看房id
@property (nonatomic, strong) NSString *hk_houseShowingsId;
// 活动流程
@property (nonatomic, strong) NSString *hk_showingsActivityProcess;
// 截止时间
@property (nonatomic, strong) NSString *hk_showingsEndtime;
// 所属区域
@property (nonatomic, strong) NSString *hk_showingsErea;
// 线路介绍
@property (nonatomic, strong) NSString *hk_showingsLineIntroduction;
// 最高优惠
@property (nonatomic, strong) NSString *hk_showingsMaxPreferential;
// 看房团标题
@property (nonatomic, strong) NSString *hk_showingsTitle;
// 报名热线
@property (nonatomic, strong) NSString *hk_tel;
// 总人数
@property (nonatomic, strong) NSString *hk_totalPeopleQty;

@end
