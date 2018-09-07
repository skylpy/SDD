//
//  GRDetailNViewController.h
//  SDD
//  全国项目（无优惠
//  Created by hua on 15/9/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface GRDetailNViewController : XHBaseViewController

// 房子id
@property (nonatomic, strong) NSString *houseID;
// 活动id
@property (nonatomic, strong) NSString *activityCategoryId;

@property (nonatomic, strong) NSString *hr_activityCategoryId;
@property (nonatomic, assign) NSInteger type;

@end
