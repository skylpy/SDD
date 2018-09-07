//
//  OrderConfirmationViewController.h
//  SDD
//  订单确认 类型分团租和特价铺
//  Created by hua on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmationViewController : UIViewController

/*- 团租在线选房 -*/

// 标题
@property (nonatomic, retain) NSString *theTitle;
// 所选单元(团租)
@property (nonatomic, retain) NSArray *unitArr;
// 房子id
@property (nonatomic, strong) NSString *houseID;

/*- >>新<< 团租在线选房 -*/

// 常规信息
@property (nonatomic, retain) NSArray *commonData;
// 铺位
@property (nonatomic, retain) NSArray *storesData;
// 当前类型id
@property (nonatomic, retain) NSString *currentTypeCategoryId;
// 当前业态id
@property (nonatomic, retain) NSString *currentIndustryCategoryId;
// 当前铺位id
@property (nonatomic, retain) NSArray *currentUnitId;
/*- 特价铺 -*/

// 户型
@property (nonatomic, retain) NSString *ald;
// 单元
@property (nonatomic, retain) NSString *unit;
// 定金
@property (nonatomic, strong) NSString *orderMoney;
// 优惠价
@property (nonatomic, strong) NSString *preferentialPrice;

// 订单来源
@property (nonatomic, strong) NSString *orderType;

@end
