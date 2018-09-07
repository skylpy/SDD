//
//  GRMoreDetailViewController.h
//  SDD
//  大长条续
//  Created by hua on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"
#import "HouseDetailModel.h"

@interface GRMoreDetailViewController : XHBaseViewController

// 房子id
@property (nonatomic, strong) NSString *houseID;
// 数据
@property (nonatomic, strong) HouseDetailModel *model;                        // 模型
// 活动id
@property (nonatomic, strong) NSString *activityCategoryId;

// block
typedef void(^ReturnHouseID) (NSString *theHouseID);

@property (nonatomic, copy) ReturnHouseID returnBlock;
- (void)valueReturn:(ReturnHouseID)block;

@end
