//
//  GRDetailViewController.h
//  SDD
//  团租详情（大长条
//  Created by hua on 15/4/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface GRDetailViewController : XHBaseViewController

// 房子id
@property (nonatomic, strong) NSString *houseID;
// 活动id
@property (nonatomic, strong) NSString *activityCategoryId;

//哪个界面传递
@property (nonatomic,assign)NSInteger deliverInt;

@property (nonatomic, strong) NSString *hr_activityCategoryId;
@property (nonatomic, assign) NSInteger type;
@end
