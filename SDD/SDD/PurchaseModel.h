//
//  PurchaseModel.h
//  SDD
//
//  Created by mac on 15/12/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseModel :NSObject

@property (nonatomic,copy) NSNumber *isAttention;
@property (nonatomic,copy) NSString *storePropertyCondition;
@property (nonatomic,copy) NSNumber *industryCategoryId1;
@property (nonatomic,copy) NSNumber *storeRentPrice;
@property (nonatomic,copy) NSNumber *storeArea;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSString *storeDescription;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *storeSn;
@property (nonatomic,copy) NSString *storeBuilding;
@property (nonatomic,copy) NSNumber *endTime;
@property (nonatomic,copy) NSNumber *lastUpdate;
@property (nonatomic,copy) NSNumber *storeFloor;
@property (nonatomic,copy) NSNumber *houseId;
@property (nonatomic,copy) NSNumber *storeId;
@property (nonatomic,copy) NSString *imageUrls;
@property (nonatomic,copy) NSNumber *addTime;
@property (nonatomic,copy) NSNumber *industryCategoryId2;
@property (nonatomic,copy) NSNumber *ifShow;
@property (nonatomic,copy) NSString *defaultImage;
@property (nonatomic,copy) NSNumber *totalAttentions;

+(instancetype)PurchaseDict:(NSDictionary *)dict;

@end
