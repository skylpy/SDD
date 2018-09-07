//
//  SettlementViewController.h
//  SDD
//  结算
//  Created by hua on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementViewController : UIViewController

// 房子名
@property (nonatomic, strong) NSString *grTitle;
// 房子id
@property (nonatomic, strong) NSString *houseID;
// 所选单元(团租)
@property (nonatomic, retain) NSArray *unitArr;
// 单元（特价铺)
@property (nonatomic, retain) NSString *unit;
// 租房人
@property (nonatomic, strong) NSString *realName;
// 手机号
@property (nonatomic, strong) NSString *phone;

// 订单来源
@property (nonatomic, strong) NSString *orderType;

@end
