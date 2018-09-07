//
//  HouseChooseModel.h
//  SDD
//
//  Created by hua on 15/4/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseChooseModel : NSObject

/*- 楼栋 -*/

// 建筑id
@property (nonatomic, strong) NSString *hc_buildingId;
// 建筑名
@property (nonatomic, strong) NSString *hc_buildingName;
// 类型名
@property (nonatomic, strong) NSString *hc_formatName;
// 房子id
@property (nonatomic, strong) NSString *hc_houseId;

/*- 楼层 -*/

// 楼层id
@property (nonatomic, strong) NSString *hc_floorId;
// 楼层名
@property (nonatomic, strong) NSString *hc_floorName;
// 描述
@property (nonatomic, strong) NSString *hc_description;
// 房子地址
@property (nonatomic, strong) NSString *hc_houseAddress;
// 房子图片
@property (nonatomic, strong) NSString *hc_imageUrl;
// 楼层
@property (nonatomic, strong) NSString *hc_floor;

/*- 单元列表 -*/

// 户型id
@property (nonatomic, strong) NSString *hc_houseModelId;
// 是否租出
@property (nonatomic, strong) NSString *hc_isRent;
// 单元id
@property (nonatomic, strong) NSString *hc_unitId;
// 单元名
@property (nonatomic, strong) NSString *hc_unitName;


/*- 新在线选房  -*/
// 业态
@property (nonatomic, strong) NSArray *hc_houseIndustryCategorys;
// 类型选择
@property (nonatomic, strong) NSArray *hc_houseTypeCategorys;
// 具体属性
@property (nonatomic, strong) NSArray *hc_houseBuildings;
// 团租截止日
@property (nonatomic, strong) NSString *hc_rentPreferentialEndtimeStr;
// 品牌进驻须知
@property (nonatomic, strong) NSString *hc_brandPresenceNotice;
// 团租规则
@property (nonatomic, strong) NSString *hc_rentRule;


@end
