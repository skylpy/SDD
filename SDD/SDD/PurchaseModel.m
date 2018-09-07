//
//  PurchaseModel.m
//  SDD
//
//  Created by mac on 15/12/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PurchaseModel.h"

@implementation PurchaseModel

+(instancetype)PurchaseDict:(NSDictionary *)dict{

    PurchaseModel * model = [[self alloc] init];
    model.isAttention = dict[@"isAttention"];
    model.storePropertyCondition = dict[@"storePropertyCondition"];
    model.industryCategoryId1 = dict[@"industryCategoryId1"];
    model.storeRentPrice = dict[@"storeRentPrice"];
    model.storeArea = dict[@"storeArea"];
    model.categoryName = dict[@"categoryName"];
    model.storeDescription = dict[@"storeDescription"];
    model.storeName = dict[@"storeName"] ;
    model.storeSn = dict[@"storeSn"];
    model.storeBuilding = dict[@"storeBuilding"];
    model.endTime = dict[@"endTime"];
    model.lastUpdate = dict[@"lastUpdate"];
    model.storeFloor = dict[@"storeFloor"];
    model.houseId = dict[@"houseId"];
    model.storeId = dict[@"storeId"];
    model.imageUrls = dict[@"imageUrls"];
    model.addTime = dict[@"addTime"];
    model.industryCategoryId2 = dict[@"industryCategoryId2"];
    model.ifShow = dict[@"ifShow"];
    model.defaultImage = dict[@"defaultImage"];
    model.totalAttentions = dict[@"totalAttentions"];
    
    
    return model;
}

@end
