//
//  FranchiseesDetailModel.m
//  SDD
//
//  Created by hua on 15/6/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FranchiseesDetailModel.h"

@implementation FranchiseesDetailModel

+ (instancetype)franchiseesDetailWithDict:(NSDictionary *)dict{
    
    FranchiseesDetailModel *model = [[self alloc] init];
    
     model.regionalLocationCategoryIdList = dict[@"regionalLocationCategoryIdList"];
     model.shopModelCategoryIdList = dict[@"shopModelCategoryIdList"];
    
     model.honestyUrls = dict[@"honestyUrls"];
//     model.realMapUrls = dict[@"realMapUrls"];
     model.joinConditions = dict[@"joinConditions"];
     model.joinProcess = dict[@"joinProcess"];
     model.totalInvestmentAmount = dict[@"totalInvestmentAmount"];
     model.businessArea = dict[@"businessArea"];
     model.traffic = dict[@"traffic"];
     model.averageConsumption = dict[@"averageConsumption"];
     model.referenceStore = dict[@"referenceStore"];
     model.floor = dict[@"floor"];
     model.volume = dict[@"volume"];
     model.revenue = dict[@"revenue"];
     model.operatingCosts = dict[@"operatingCosts"];
     model.depreciationShare = dict[@"depreciationShare"];
    
    model.grossProfit = dict[@"grossProfit"];
    model.annualProfit = dict[@"annualProfit"];
    model.paybackPeriod = dict[@"paybackPeriod"];
    model.responseRate = dict[@"responseRate"];
    model.joinPosters = dict[@"joinPosters"];

  
    model.preferredProperty = dict[@"preferredProperty"];
    model.consultantList = dict[@"consultantList"];

    model.marketOutlook = dict[@"marketOutlook"];
    model.preferentialContent = dict[@"preferentialContent"];
    model.foundedTime = dict[@"foundedTime"];
    model.suitableGroup = dict[@"suitableGroup"];
    model.planYearExtension = dict[@"planYearExtension"];
    model.fd_storeName = dict[@"storeName"];
    model.fd_brandName = dict[@"brandName"];
    model.fd_storeAmount = dict[@"storeAmount"];
    model.fd_defaultImage = dict[@"defaultImage"];
    model.fd_type = dict[@"type"];
    model.fd_industryCategoryName = dict[@"industryCategoryName"];
    model.fd_regionalLocationCategoryName = dict[@"regionalLocationCategoryName"];
    model.fd_areaCategoryName = dict[@"areaCategoryName"];
    model.fd_cooperationPeriodCategoryName = dict[@"cooperationPeriodCategoryName"];
    model.fd_shopModelCategoryName = dict[@"shopModelCategoryName"];
    model.fd_brandPositioningCategoryName = dict[@"brandPositioningCategoryName"];
    model.fd_companyName = dict[@"companyName"];
    model.fd_expandingRegion = dict[@"expandingRegion"];
    model.fd_propertyTypeCategoryName = dict[@"propertyTypeCategoryName"];
    model.fd_investmentAmountCategoryName = dict[@"investmentAmountCategoryName"];
    model.fd_brandDescription = dict[@"brandDescription"];
    model.fd_isCollectioned = dict[@"isCollectioned"];
    model.fd_collectionQty = dict[@"collectionQty"];
    model.fd_joinedQty = dict[@"joinedQty"];
    model.fd_dynamicList = dict[@"dynamicList"];
    model.fd_propertyUsageCategoryId = dict[@"propertyUsageCategoryId"];
    model.fd_propertyUsageCategoryName = dict[@"propertyUsageCategoryName"];
    model.fd_imageList = dict[@"imageList"];
    model.fd_propertyDescription = dict[@"propertyDescription"];
    model.fd_regionList = dict[@"regionList"];
    model.fd_brandName = dict[@"brandName"];
    model.fd_storeName = dict[@"storeName"];
    model.fd_totalInvestmentAmount = dict[@"totalInvestmentAmount"];
    model.fd_operatingCycle = dict[@"operatingCycle"];
    model.fd_profitCycle = dict[@"profitCycle"];
    model.fd_businessArea = dict[@"businessArea"];
    model.fd_traffic = dict[@"traffic"];
    model.fd_averageConsumption = dict[@"averageConsumption"];
    model.fd_quarterRevenues = dict[@"quarterRevenues"];
    model.fd_joinAdvantage = dict[@"joinAdvantage"];
    model.fd_recommendList = dict[@"recommendList"];
    model.fd_brandContacts = dict[@"brandContacts"];
    model.fd_jobTitle = dict[@"jobTitle"];
    model.fd_precinct = dict[@"precinct"];
    model.fd_tel = dict[@"tel"];
    model.fd_tel400 = dict[@"tel400"];
    model.fd_tel400Extra = dict[@"tel400Extra"];
    model.fd_phone = dict[@"phone"];
    model.fd_email = dict[@"email"];
    model.fd_address = dict[@"address"];
    model.fd_commentList = dict[@"commentList"];    
    model.fd_brandId = dict[@"brandId"];
    model.fd_chatUser = dict[@"chatUser"];
    model.fd_storeQty = dict[@"storeQty"];
    model.fd_discountCoupons = dict[@"discountCoupons"];
    
    model.joinConditions = dict[@"joinConditions"];
    model.joinProcess = dict[@"joinProcess"];
    model.totalInvestmentAmount = dict[@"totalInvestmentAmount"];
    model.businessArea = dict[@"businessArea"];
    model.traffic = dict[@"traffic"];
    model.averageConsumption = dict[@"averageConsumption"];
    model.referenceStore = dict[@"referenceStore"];
    model.floor = dict[@"floor"];
    model.volume = dict[@"volume"];
    model.revenue = dict[@"revenue"];
    model.operatingCosts = dict[@"operatingCosts"];
    model.depreciationShare = dict[@"depreciationShare"];
    model.grossProfit = dict[@"grossProfit"];
    model.annualProfit = dict[@"annualProfit"];
    model.paybackPeriod = dict[@"paybackPeriod"];
    model.responseRate = dict[@"responseRate"];
    model.joinPosters = dict[@"joinPosters"];
    
    return model;
}

@end
