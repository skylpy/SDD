//
//  ActivityDataViewController.h
//  SDD
//
//  Created by mac on 15/12/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"
#import "ActivityNModel.h"

@interface ActivityDataViewController : XHBaseViewController

@property (retain,nonatomic)NSNumber * activityId;
@property (retain,nonatomic)NSString * titles;
@property (retain,nonatomic)NSNumber * activityTime;
@property (retain,nonatomic)NSNumber * isSignup;//报名
@property (retain,nonatomic)NSNumber * isSponsor;//赞助

@property (retain,nonatomic)ActivityNModel * model ;

@end
