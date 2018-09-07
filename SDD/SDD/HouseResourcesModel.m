//
//  HouseResourcesModel.m
//  SDD
//
//  Created by hua on 15/4/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseResourcesModel.h"

@implementation HouseResourcesModel

+ (instancetype)hrWithDict:(NSDictionary *)dict {
    
    HouseResourcesModel *model = [[self alloc] init];
    
    model.hr_address = dict[@"address"];
    model.hr_defaultImage = dict[@"defaultImage"];
    model.hr_developersId = dict[@"developersId"];
    model.hr_houseId = dict[@"houseId"];
    model.hr_houseName = dict[@"houseName"];
    model.hr_longitude = dict[@"longitude"];
    model.hr_perferentialContent = [dict[@"perferentialContent"] isEqual:[NSNull null]]?@"":dict[@"perferentialContent"];
    model.hr_rentPreferentialContent = [dict[@"rentPreferentialContent"] isEqual:[NSNull null]]?@"":dict[@"rentPreferentialContent"];
    model.hr_preferentialEndtime = dict[@"preferentialEndtime"];
    model.hr_price = dict[@"price"];
    model.hr_tel = dict[@"tel"];
    model.hr_activityCategoryId = dict[@"activityCategoryId"];
    model.hr_buyPrice = dict[@"buyPrice"];
    model.hr_planFormat = dict[@"planFormat"];
    model.hr_rentPrice = dict[@"rentPrice"];
    model.hr_isActivityHouse = dict[@"isActivityHouse"];
    model.hr_merchantsStatus = dict[@"merchantsStatus"];
    model.hr_brandName = dict[@"brandName"];
    model.hr_totalInvestmentAmount = dict[@"totalInvestmentAmount"];
    model.hr_industryCategoryName = dict[@"industryCategoryName"];
    model.hr_storeAmount = dict[@"storeAmount"];
    model.hr_title = dict[@"title"];
    model.hr_summary = dict[@"summary"];
    model.hr_icon = dict[@"icon"];
    model.hr_brandId = dict[@"brandId"];
    model.hr_dynamicId = dict[@"dynamicId"];
    model.hr_buildingArea = dict[@"buildingArea"];
    model.hr_type = dict[@"type"];
    
    return model;    
}

@end
