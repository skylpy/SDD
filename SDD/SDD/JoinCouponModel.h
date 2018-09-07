//
//  JoinCouponModel.h
//  SDD
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinCouponModel : NSObject

@property (nonatomic,copy) NSString *discount;
@property (nonatomic,copy) NSString *realName;
@property (nonatomic,copy) NSString *usedDescription;
@property (nonatomic,copy) NSNumber *userDiscountCouponsId;
@property (nonatomic,copy) NSNumber *isUsed;
@property (nonatomic,copy) NSNumber *usedTime;
@property (nonatomic,copy) NSNumber *userId;
@property (nonatomic,copy) NSNumber *discountId;
@property (nonatomic,copy) NSNumber *brandId;
@property (nonatomic,copy) NSNumber *endTime;
@property (nonatomic,copy) NSString *maxPreperentialStr;
@property (nonatomic,copy) NSString *discountNumber;
@property (nonatomic,copy) NSString *brandLogo;
@property (nonatomic,copy) NSString *brandName;
@property (nonatomic,copy) NSNumber *addTime;
@property (nonatomic,copy) NSString *preferentialDescription;

@end
