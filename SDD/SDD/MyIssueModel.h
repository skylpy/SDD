//
//  MyIssueModel.h
//  SDD
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyIssueModel : NSObject
//项目发布
@property (nonatomic,copy) NSString *houseName;
@property (nonatomic,copy) NSNumber *status;
@property (nonatomic,copy) NSNumber *addTime;
@property (nonatomic,copy) NSString *defaultImage;
@property (nonatomic,copy) NSNumber *houseId;
@property (nonatomic,copy) NSNumber *houseFirstId;

//品牌发布
@property (nonatomic,copy) NSString *industryCategoryName;
@property (nonatomic,copy) NSNumber *intentionClientCount;
@property (nonatomic,copy) NSNumber *ifShow;
@property (nonatomic,copy) NSNumber *collectionQty;
@property (nonatomic,copy) NSString *rewardCommission;
@property (nonatomic,copy) NSString *investmentPolicy;

@property (nonatomic,copy) NSNumber *type;
@property (nonatomic,copy) NSNumber *joinedQty;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *maxPreferentialStr;
@property (nonatomic,copy) NSNumber *endTime;
@property (nonatomic,copy) NSNumber *maxPreferential;
@property (nonatomic,copy) NSNumber *commissionMin;
@property (nonatomic,copy) NSString *investmentAmountCategoryName;
@property (nonatomic,copy) NSString *brandContacts;
@property (nonatomic,copy) NSNumber *recentlyDealCount;
@property (nonatomic,copy) NSString *characterCategoryName;
@property (nonatomic,copy) NSString *brandLogo;
@property (nonatomic,copy) NSNumber *commissionMax;
@property (nonatomic,copy) NSString *brandDescription;
@property (nonatomic,copy) NSString *brandName;
@property (nonatomic,copy) NSNumber *brandId;
@property (nonatomic,copy) NSString *propertyTypeCategoryName;
@property (nonatomic,copy) NSNumber *discountId;
@property (nonatomic,copy) NSNumber *storeAmount;
@property (nonatomic,copy) NSNumber *cooperationManagerCount;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSNumber *discount;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSNumber *cooperationEndTime;
@property (nonatomic,copy) NSString *totalInvestmentAmount;

@end
