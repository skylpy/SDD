//
//  FindBrankModel.m
//  SDD
//
//  Created by hua on 15/6/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FindBrankModel.h"

@implementation FindBrankModel

+ (instancetype)findBrankWithDict:(NSDictionary *)dict{
    
    FindBrankModel *model = [[self alloc] init];
    
    model.categoryName = dict[@"categoryName"];
    model.regionalLocationCategoryId = dict[@"regionalLocationCategoryId"];
    model.investmentAmountCategoryId = dict[@"investmentAmountCategoryId"];
    model.children = dict[@"children"];
    model.industryCategoryId = dict[@"industryCategoryId"];
    model.regionName = dict[@"regionName"];
    model.regionId = dict[@"regionId"];
    model.parentId = dict[@"parentId"];
    model.areaCategoryId = dict[@"areaCategoryId"];
    model.typeCategoryId = dict[@"typeCategoryId"];
    model.specialLocationCategoryId = dict[@"specialLocationCategoryId"];
    model.projectNatureCategoryId = dict[@"projectNatureCategoryId"];
    model.postCategoryId = dict[@"postCategoryId"];
    model.areaList = dict[@"areaList"];
    model.floor = dict[@"floor"];
    model.floorName = dict[@"floorName"];
    
    return model;
}

@end
