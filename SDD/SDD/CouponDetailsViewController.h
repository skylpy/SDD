//
//  CouponDetailsViewController.h
//  SDD
//
//  Created by mac on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinCouponModel.h"

@interface CouponDetailsViewController : UIViewController

@property (assign,nonatomic)int state;
@property (retain,nonatomic)UILabel * DiscountLable;
@property (retain,nonatomic)UILabel * EffectiveLabel;
@property (retain,nonatomic)JoinCouponModel * model ;

@end
