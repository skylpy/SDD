//
//  EvaluationModel.h
//  SDD
//
//  Created by hua on 15/4/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationModel : NSObject

// 平均
@property (nonatomic, strong) NSString *e_avgScore;
// 价格
@property (nonatomic, strong) NSString *e_priceScore;
// 区位
@property (nonatomic, strong) NSString *e_areaScore;
// 配套
@property (nonatomic, strong) NSString *e_supportingScore;
// 交通
@property (nonatomic, strong) NSString *e_trafficScore;
// 政策
@property (nonatomic, strong) NSString *e_policyscore;
// 竞争力
@property (nonatomic, strong) NSString *e_competescore;
// 评论列表（全部）
@property (nonatomic, strong) NSArray *e_commentList;
// （全部）
@property (nonatomic, strong) NSString *e_total;
// （精华）
@property (nonatomic, strong) NSString *e_topTotal;


//列表错
@property (nonatomic, strong) NSNumber * activityCategoryId ;
@property (nonatomic, strong) NSString * address ;
@property (nonatomic, strong) NSNumber * buildingArea ;
@property (nonatomic, strong) NSString * buyPreferentialContent ;
@property (nonatomic, strong) NSNumber * buyPreferentialEndtime ;
@property (nonatomic, strong) NSString * commissionDescription ;
@property (nonatomic, strong) NSNumber * commissionMax ;
@property (nonatomic, strong) NSNumber * commissionMin ;
@property (nonatomic, strong) NSNumber * cooperationEndTime ;
@property (nonatomic, strong) NSNumber * cooperationManagerCount ;
@property (nonatomic, strong) NSNumber * countiesId ;
@property (nonatomic, strong) NSString * countiesName ;
@property (nonatomic, strong) NSString * defaultImage ;
@property (nonatomic, strong) NSNumber * houseId ;
@property (nonatomic, strong) NSString * houseName ;
@property (nonatomic, strong) NSNumber * intentionClientCount ;
@property (nonatomic, strong) NSString * latitude ;
@property (nonatomic, strong) NSString * longitude ;
@property (nonatomic, strong) NSNumber * merchantsStatus ;
@property (nonatomic, strong) NSNumber * openedTime ;
@property (nonatomic, strong) NSString * planFormat ;
@property (nonatomic, strong) NSNumber * price ;
@property (nonatomic, strong) NSString * projectCircleDescription ;
@property (nonatomic, strong) NSNumber * recentlyDealCount ;
@property (nonatomic, strong) NSString * rentPreferentialContent ;
@property (nonatomic, strong) NSNumber * rentPreferentialEndtime ;
@property (nonatomic, strong) NSNumber * rentPriceMax ;
@property (nonatomic, strong) NSNumber * rentPriceMin ;
@property (nonatomic, strong) NSNumber * sort ;
@property (nonatomic, strong) NSNumber * tel ;
@property (nonatomic, strong) NSNumber * telExtra ;

//点评列表
@property (nonatomic, strong) NSNumber * addTime;
@property (nonatomic, strong) NSNumber * areaScore ;
@property (nonatomic, strong) NSString * avgScore ;
@property (nonatomic, strong) NSNumber * commentId ;
@property (nonatomic, strong) NSNumber * competeScore ;
@property (nonatomic, strong) NSString * hd_description ;
//@property (nonatomic, strong) NSNumber * houseId ;
@property (nonatomic, strong) NSString * icon ;
@property (nonatomic, strong) NSNumber * isSystemUser ;
@property (nonatomic, strong) NSNumber * isTop ;
@property (nonatomic, strong) NSNumber * likeTotal ;
@property (nonatomic, strong) NSNumber * milieuScore ;
@property (nonatomic, strong) NSNumber * policyScore ;
@property (nonatomic, strong) NSNumber * priceScore ;
@property (nonatomic, strong) NSString * realName ;
@property (nonatomic, strong) NSNumber * replyTotal ;
@property (nonatomic, strong) NSNumber * supportingScore ;
@property (nonatomic, strong) NSNumber * trafficScore ;
@property (nonatomic, strong) NSNumber * treadTotal ;
@property (nonatomic, strong) NSNumber * userId ;

@end
