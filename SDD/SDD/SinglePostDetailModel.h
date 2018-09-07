//
//  SinglePostDetailModel.h
//  SDD
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinglePostDetailModel :NSObject

@property (nonatomic,copy) NSNumber *treadQty;
@property (nonatomic,copy) NSString *answerContent;
@property (nonatomic,copy) NSNumber *goodsAnswerTime;
@property (nonatomic,copy) NSNumber *likeQty;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSArray *questionsContent;
@property (nonatomic,copy) NSString *authorIcon;
@property (nonatomic,copy) NSArray *likeOrTread;
@property (nonatomic,copy) NSNumber *isDelete;
@property (nonatomic,copy) NSNumber *questionsId;
@property (nonatomic,copy) NSNumber *userId;
@property (nonatomic,copy) NSNumber *rewardScore;
@property (nonatomic,copy) NSNumber *addTime;
@property (nonatomic,copy) NSNumber *isGoodsAnswer;
@property (nonatomic,copy) NSNumber *autoClosed;
@property (nonatomic,copy) NSNumber *answerId;
@property (nonatomic,copy) NSNumber *reportQty;

//相关提问
@property (nonatomic,copy) NSNumber * AnswerQty;
@property (nonatomic,copy) NSNumber *finishTime;
@property (nonatomic,copy) NSNumber *goodsUserId;
@property (nonatomic,copy) NSNumber *goodsAnswerId;
@property (nonatomic,copy) NSString *goodsAnswerContent;
@property (nonatomic,copy) NSNumber *totalAnswerQty;
@property (nonatomic,copy) NSArray *tagList;
@property (nonatomic,copy) NSString *content;

@end
