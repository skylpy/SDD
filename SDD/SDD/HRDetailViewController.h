//
//  HRDetailViewController.h
//  SDD
//  房源详情
//  Created by hua on 15/4/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface HRDetailViewController : XHBaseViewController

// 标题
@property (nonatomic, retain) NSString *hrTitle;
// 房子id
@property (nonatomic, strong) NSString *houseID;
// 活动id
@property (nonatomic, strong) NSString *activityCategoryId;

@end
