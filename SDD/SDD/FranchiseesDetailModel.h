//
//  FranchiseesDetailModel.h
//  SDD
//  加盟商详情
//  Created by hua on 15/6/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FranchiseesDetailModel : NSObject

//
@property (nonatomic, copy) NSString *fd_addTime;
//
@property (nonatomic, copy) NSString *fd_address;
//
@property (nonatomic, copy) NSString *fd_areaCategoryId;
//
@property (nonatomic, copy) NSString *fd_areaCategoryName;
//
@property (nonatomic, copy) NSString *fd_averageConsumption;
//
@property (nonatomic, copy) NSString *fd_brandContacts;
//
@property (nonatomic, copy) NSString *fd_brandDescription;
//
@property (nonatomic, copy) NSString *fd_brandId;
//
@property (nonatomic, copy) NSString *fd_brandLogo;
//
@property (nonatomic, copy) NSString *fd_brandName;
//
@property (nonatomic, copy) NSString *fd_brandPositioningCategoryId;
//
@property (nonatomic, copy) NSString *fd_brandPositioningCategoryName;
//
@property (nonatomic, copy) NSString *fd_businessArea;
//
@property (nonatomic, copy) NSString *fd_characterCategoryId;
//
@property (nonatomic, copy) NSString *fd_collectionQty;
//
@property (nonatomic, copy) NSArray *fd_commentList;
//
@property (nonatomic, copy) NSString *fd_companyName;
//
@property (nonatomic, copy) NSString *fd_cooperationPeriodCategoryId;
//
@property (nonatomic, copy) NSString *fd_cooperationPeriodCategoryName;
//
@property (nonatomic, copy) NSString *fd_defaultImage;
//
@property (nonatomic, copy) NSArray *fd_dynamicList;
//
@property (nonatomic, copy) NSString *fd_email;
//
@property (nonatomic, copy) NSString *fd_expandingRegion;
//
@property (nonatomic, copy) NSString *fd_ifShow;
//
@property (nonatomic, copy) NSDictionary *fd_imageList;
//
@property (nonatomic, copy) NSString *fd_industryCategoryId;
//
@property (nonatomic, copy) NSString *fd_industryCategoryId1;
//
@property (nonatomic, copy) NSString *fd_industryCategoryId2;
//
@property (nonatomic, copy) NSString *fd_industryCategoryName;
//
@property (nonatomic, copy) NSString *fd_investmentAmountCategoryId;
//
@property (nonatomic, copy) NSString *fd_investmentAmountCategoryName;
//
@property (nonatomic, copy) NSString *fd_isCollectioned;
//
@property (nonatomic, copy) NSString *fd_isDelete;
//
@property (nonatomic, copy) NSString *fd_jobTitle;
//
@property (nonatomic, copy) NSString *fd_joinAdvantage;
//
@property (nonatomic, copy) NSString *fd_joinedQty;
//
@property (nonatomic, copy) NSString *fd_operatingCycle;
//
@property (nonatomic, copy) NSString *fd_phone;
//
@property (nonatomic, copy) NSString *fd_precinct;
//
@property (nonatomic, copy) NSString *fd_profitCycle;
//
@property (nonatomic, copy) NSString *fd_propertyDescription;
//
@property (nonatomic, copy) NSString *fd_propertyTypeCategoryId;
//
@property (nonatomic, copy) NSString *fd_propertyTypeCategoryName;
//
@property (nonatomic, copy) NSString *fd_propertyUsageCategoryId;
//
@property (nonatomic, copy) NSString *fd_propertyUsageCategoryName;
//
@property (nonatomic, copy) NSString *fd_quarterRevenues;
//
@property (nonatomic, copy) NSArray *fd_recommendList;
//
@property (nonatomic, copy) NSArray *fd_regionList;

@property (nonatomic, copy) NSArray *regionalLocationCategoryIdList ;//区位位置Id数组

@property (nonatomic, copy) NSString *fd_regionalLocationCategoryId;
//
@property (nonatomic, copy) NSString *fd_regionalLocationCategoryName;
//
@property (nonatomic, copy) NSString *fd_shopModelCategoryId;
//
@property (nonatomic, copy) NSString *fd_shopModelCategoryName;
@property (nonatomic, copy) NSArray  * shopModelCategoryIdList; //开店模式Id数组
//
@property (nonatomic, copy) NSString *fd_sort;
//
@property (nonatomic, copy) NSString *fd_status;
//
@property (nonatomic, copy) NSString *fd_storeAmount;
//
@property (nonatomic, copy) NSString *fd_storeName;
//
@property (nonatomic, copy) NSString *fd_tel;
//
@property (nonatomic, copy) NSString *fd_tel400;
//
@property (nonatomic, copy) NSString *fd_tel400Extra;
//
@property (nonatomic, copy) NSString *fd_totalInvestmentAmount;
//
@property (nonatomic, copy) NSString *fd_traffic;
//
@property (nonatomic, copy) NSString *fd_type;
//
@property (nonatomic, copy) NSString *fd_userId;
//
@property (nonatomic, copy) NSDictionary *fd_chatUser;
//
@property (nonatomic, copy) NSDictionary *fd_storeQty;
//
@property (nonatomic, copy) NSDictionary *fd_discountCoupons;

//
@property (nonatomic, copy) NSString *planYearExtension;

@property (nonatomic,copy)  NSString *suitableGroup;

@property (nonatomic,copy)  NSString *foundedTime;

@property (nonatomic,copy)  NSString *preferentialContent;

@property (nonatomic,copy)  NSString *marketOutlook;

@property (nonatomic,copy)NSString *preferredProperty;

@property (nonatomic, copy) NSArray *consultantList;
//诚信资料
@property (nonatomic,copy)NSArray *honestyUrls;
//实景图
@property (nonatomic,copy)NSArray *realMapUrls;

//终端展示
@property (nonatomic,copy)NSArray *terminalUrls;
@property (nonatomic,copy)NSString *joinConditions; //加盟条件;
@property (nonatomic,copy)NSString *joinProcess; //加盟流程
@property (nonatomic,copy)NSString *totalInvestmentAmount; //投资金额
@property (nonatomic,copy)NSString *businessArea; //经营面积 单位（m2）
@property (nonatomic,copy)NSString *traffic; //客流量 单位（人/天）
@property (nonatomic,copy)NSString *averageConsumption; //人均消费 单位（元/人）
@property (nonatomic,copy)NSString *referenceStore; //参考店铺
@property (nonatomic,copy)NSString *floor; //所在楼层

@property (nonatomic,copy)NSString *volume; //成交量
@property (nonatomic,copy)NSString *revenue; //营业收入
@property (nonatomic,copy)NSString *operatingCosts; //运营成本
@property (nonatomic,copy)NSString *depreciationShare; //分摊折旧
@property (nonatomic,copy)NSString *grossProfit; //毛利
@property (nonatomic,copy)NSString *annualProfit; //年利润
@property (nonatomic,copy)NSString *paybackPeriod; //回报周期
@property (nonatomic,copy)NSString *responseRate; //回报率

@property (nonatomic,copy)NSString *joinPosters; //加盟海报图片




+ (instancetype)franchiseesDetailWithDict:(NSDictionary *)dict;

@end
