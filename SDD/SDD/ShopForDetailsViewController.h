//
//  ShopForDetailsViewController.h
//  SDD
//
//  Created by mac on 15/12/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface ShopForDetailsViewController : XHBaseViewController

@property (retain,nonatomic) NSNumber * storeId;
// 房子id
@property (nonatomic, strong) NSString *houseID;

@property (nonatomic, strong) NSString * canAppointmentSign;

@property (nonatomic, strong) NSString *hr_activityCategoryId;

@property (nonatomic, assign) NSInteger type;
@end
