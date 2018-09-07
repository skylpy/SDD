//
//  GetCouponViewController.h
//  SDD
//  领取折扣券(我要加盟)
//  Created by hua on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface GetCouponViewController : XHBaseViewController

@property (nonatomic, strong) NSString *brankName;
@property (nonatomic, assign) NSDictionary *discountCoupons;

@end
