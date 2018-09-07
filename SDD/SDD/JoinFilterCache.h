//
//  JoinFilterCache.h
//  SDD
//
//  Created by Cola on 15/7/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinFilterCache : NSObject

/**
 * 返回面积缓存
 **/
+ (void)AreaFilterCache:(NSMutableArray *)dict;

/**
 * 投资金额
 **/
+ (void)InvestmentFilterCache:(NSMutableArray *)cache;

/**
 *物业类型
 **/
//+ (void)PropertyFilterCache:(NSMutableArray *)cache;

/**
 *品牌性质
 **/
+ (void)CharacterFilterCache:(NSMutableArray *)cache;
@end
