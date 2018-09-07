//
//  HouseDetailModel.h
//  SDD
//
//  Created by hua on 15/4/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseDetailModel : NSObject

// 特价铺表
@property (nonatomic, strong) NSArray *hd_activityList;
// 项目顾问列表
@property (nonatomic, strong) NSArray *hd_consultantList;
// 品牌顾问列表
@property (nonatomic, strong) NSArray *hd_brandConsultantList;
// 动态列表
@property (nonatomic, strong) NSArray *hd_dynamicList;
// 房子（楼盘参数、楼盘简介）
@property (nonatomic, strong) NSDictionary *hd_house;
// 在线评房
@property (nonatomic, strong) NSDictionary *hd_houseCommentDTO;
// 开发商背景
@property (nonatomic, strong) NSDictionary *hd_houseDeveloper;
// 优惠
@property (nonatomic, strong) NSDictionary *hd_housePreferential;
// 看房团
@property (nonatomic, strong) NSDictionary *hd_houseShowings;
// 房子图片
@property (nonatomic, strong) NSDictionary *hd_images;
// 户型
@property (nonatomic, strong) NSArray *hd_modelList;
// 房价走势
@property (nonatomic, strong) NSDictionary *hd_priceMap;
// 标签
@property (nonatomic, strong) NSArray *hd_tagList;
// 同类项目
@property (nonatomic, strong) NSArray *hd_similarsList;
// 周边项目
@property (nonatomic, strong) NSArray *hd_surroundingsList;
// 相关团购推荐
@property (nonatomic, strong) NSArray *hd_recommendBuyList;
// 相关团租推荐
@property (nonatomic, strong) NSArray *hd_recommendRentList;
// 相关团购推荐（房源）
@property (nonatomic, strong) NSArray *hd_buyList;
// 相关团购推荐（房源）
@property (nonatomic, strong) NSArray *hd_rentList;
// 主力店
@property (nonatomic, strong) NSArray *hd_mainStoreList;
// 品牌
@property (nonatomic, strong) NSArray *hd_brandList;
// 主力品牌
@property (nonatomic, strong) NSArray *hd_mainBrandList;
// 意向品牌
@property (nonatomic, strong) NSArray *hd_intentBrandList;
// 最近品牌
@property (nonatomic, strong) NSArray *hd_newBrandList;

//铺位招商列表
@property (nonatomic, strong) NSArray * hd_houseStoreList;
//铺位招商数量
@property (nonatomic, strong) NSString * hd_houseStoreTotalSize;

+ (instancetype)hdWithDict:(NSDictionary *)dict;

@end
