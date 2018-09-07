//
//  GPDetailViewController.h
//  sdd_iOS_personal
//  团购详情
//  Created by hua on 15/4/7.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface GPDetailViewController : XHBaseViewController

// 房子id
@property (nonatomic, strong) NSString *houseID;
// 活动id
@property (nonatomic, strong) NSString *activityCategoryId;
@property (nonatomic, strong) NSString *hr_activityCategoryId;

@property (nonatomic, assign) NSInteger type;
@end
