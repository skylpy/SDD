//
//  IntegralModel.h
//  SDD
//
//  Created by mac on 15/12/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralModel : NSObject

@property (retain,nonatomic)NSNumber * addTime;
@property (retain,nonatomic)NSString * defaultImage;
@property (retain,nonatomic)NSString * goodsContent;
@property (retain,nonatomic)NSString * goodsName;
@property (retain,nonatomic)NSNumber * isDelete;
@property (retain,nonatomic)NSNumber * lastUpdate;
@property (retain,nonatomic)NSString * precautions;
@property (retain,nonatomic)NSNumber * rewardGoodsId;
@property (retain,nonatomic)NSString * rewardRule;
@property (retain,nonatomic)NSNumber * score;


//积分兑换
@property (retain,nonatomic)NSNumber * goodsQty;
@property (retain,nonatomic)NSNumber * logId;
@property (retain,nonatomic)NSNumber * logTime;
@property (retain,nonatomic)NSNumber * status;
@property (retain,nonatomic)NSNumber * successTime;
@property (retain,nonatomic)NSNumber * userId;

@end
