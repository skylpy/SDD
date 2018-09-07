//
//  FindBrankModel.h
//  SDD
//  一键找品牌（各种维度
//  Created by hua on 15/6/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindBrankModel : NSObject

// 名
@property (nonatomic, strong) NSString *categoryName;
// 区位置id
@property (nonatomic, strong) NSString *regionalLocationCategoryId;
// 投资额度
@property (nonatomic, strong) NSString *investmentAmountCategoryId;
// 行业
@property (nonatomic, strong) NSMutableArray *children;
// 行业id
@property (nonatomic, strong) NSString *industryCategoryId;
// 省市名
@property (nonatomic, strong) NSString *regionName;
// 省市id
@property (nonatomic, strong) NSString *regionId;
// 省id
@property (nonatomic, strong) NSString *parentId;
// 面积id
@property (nonatomic, strong) NSString *areaCategoryId;
// 类型类别
@property (nonatomic, strong) NSString *typeCategoryId;
// 项目性质
@property (nonatomic, strong) NSString *projectNatureCategoryId;
// 特殊区位
@property (nonatomic, strong) NSString *specialLocationCategoryId;
// 职务
@property (nonatomic, strong) NSString *postCategoryId;
// 楼层名
@property (nonatomic, strong) NSString *floorName;
// 楼层id
@property (nonatomic, strong) NSString *floor;
// 楼层子
@property (nonatomic, strong) NSArray *areaList;

@property (nonatomic, strong) NSString *sort;

+ (instancetype)findBrankWithDict:(NSDictionary *)dict;

@end
