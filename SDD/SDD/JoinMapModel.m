//
//  JoinMapModel.m
//  SDD
//
//  Created by hua on 15/6/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinMapModel.h"

@implementation JoinMapModel

+ (instancetype)joinMapWithDict:(NSDictionary *)dict{
    
    JoinMapModel *model = [[self alloc] init];
    
    model.brandId = dict[@"brandId"];
    model.brandQty = dict[@"brandQty"];
    model.brandStoreRegionId = dict[@"brandStoreRegionId"];
    model.headChar = dict[@"headChar"];
    model.parentId = dict[@"parentId"];
    model.regionId = dict[@"regionId"];
    model.regionName = dict[@"regionName"];
    model.type = dict[@"type"];
    model.latitude = dict[@"latitude"];
    model.longitude = dict[@"longitude"];
    model.storesName = dict[@"storesName"];
    
    return model;
}

@end
