//
//  CPResultsModel.h
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPResultsModel : NSObject

@property (nonatomic, strong) NSString *firstPay; //首付
@property (nonatomic, strong) NSString *monthPay; //月供
@property (nonatomic, strong) NSString *totalPrice; //总价格
@property (nonatomic, strong) NSString *avgPrice; //平均价格
@property (nonatomic, strong) NSString *foreMonth; //环比上月
@property (nonatomic, strong) NSString *foreYear;  //同比去年

@property (nonatomic, strong) NSString *regionName; //所在区域
@property (nonatomic, strong) NSString *buildingStartTime; //建筑年代

- (id)initWithCPResultsDict:(NSDictionary *)dict;

@end
