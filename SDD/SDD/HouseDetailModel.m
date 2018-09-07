//
//  HouseDetailModel.m
//  SDD
//
//  Created by hua on 15/4/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseDetailModel.h"

@implementation HouseDetailModel


+ (instancetype)hdWithDict:(NSDictionary *)dict{
    
    HouseDetailModel *model = [[self alloc] init];
    
    model.hd_activityList = dict[@"activityList"];
    model.hd_consultantList = dict[@"consultantList"];
    model.hd_brandConsultantList = dict[@"brandConsultantList"];
    model.hd_dynamicList = dict[@"dynamicList"];
    model.hd_house = dict[@"house"];
    model.hd_houseCommentDTO = dict[@"houseCommentDTO"];
    model.hd_houseDeveloper = dict[@"houseDeveloper"];
    model.hd_housePreferential = dict[@"housePreferential"];
    model.hd_houseShowings = dict[@"houseShowings"];
    model.hd_images = dict[@"images"];
    model.hd_modelList = dict[@"modelList"];
    model.hd_priceMap = dict[@"priceMap"];
    model.hd_tagList = dict[@"tagList"];
    model.hd_similarsList = dict[@"similarsList"];
    model.hd_surroundingsList = dict[@"surroundingsList"];
    model.hd_recommendBuyList = dict[@"recommendBuyList"];
    model.hd_recommendRentList = dict[@"recommendRentList"];
    model.hd_buyList = dict[@"buyList"];
    model.hd_rentList = dict[@"rentList"];
    model.hd_mainStoreList = dict[@"mainStoreList"];
    model.hd_brandList = dict[@"brandList"];
    model.hd_mainBrandList = dict[@"mainBrandList"];
    model.hd_intentBrandList = dict[@"intentBrandList"];
    model.hd_newBrandList = dict[@"newBrandList"];
    model.hd_houseStoreList = dict[@"houseStoreList"];
    model.hd_houseStoreTotalSize = dict[@"houseStoreTotalSize"];

    return model;
}
@end
