//
//  RentShopsModel.h
//  CustomIntention
//
//  Created by mac on 15/7/9.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentShopsModel :NSObject

@property (nonatomic,copy) NSMutableArray *children;
@property (nonatomic,copy) NSNumber *parentId;
@property (nonatomic,copy) NSNumber *industryCategoryId;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSNumber *sort;

@property (nonatomic,copy) NSNumber * typeCategoryId;

@property (nonatomic,copy) NSNumber * projectNatureCategoryId;

//品牌加盟
@property (nonatomic,copy) NSNumber *regionId;
@property (nonatomic,copy) NSNumber *brandId;
@property (nonatomic,copy) NSString *regionName;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString * headChar;
@property (nonatomic,copy) NSNumber *brandStoreRegionId;
@property (nonatomic,copy) NSNumber *brandQty;
@property (nonatomic,copy) NSNumber *type;
@property (nonatomic,copy) NSString *latitude;

@property (nonatomic,copy) NSNumber *regionalLocationCategoryId;

@property (nonatomic,copy) NSNumber *areaCategoryId;

@property (nonatomic,copy) NSNumber *investmentAmountCategoryId;
@property (nonatomic,copy) NSNumber *maxAmount;
@property (nonatomic,copy) NSNumber *minAmount;

@property (nonatomic,copy) NSNumber *propertyTypeCategoryId;

@property (nonatomic,copy) NSNumber *characterCategoryId;

//不限
@property (nonatomic,copy) NSString * NoLimit;

//订阅动态
@property (nonatomic,copy) NSNumber * dynamicCategoryId;
@property (nonatomic,copy) NSString * url;

@property (nonatomic,copy) NSNumber * postCategoryId;

@property (nonatomic,copy) NSNumber *floor;
@property (nonatomic,copy) NSString *floorName;
@property (nonatomic,copy) NSMutableArray *areaList;

@property (retain,nonatomic)NSNumber * mainStoreCategoryId;

@end
