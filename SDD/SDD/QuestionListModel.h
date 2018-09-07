//
//  QuestionListModel.h
//  SDD
//  问题列表模型
//  Created by hua on 15/7/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionListModel : NSObject

@property (nonatomic, assign) NSInteger questionsId;

@property (nonatomic, assign) NSInteger addTime;

@property (nonatomic, assign) NSInteger finishTime;

@property (nonatomic, assign) NSInteger autoClosed;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *goodsAnswerContent;

@property (nonatomic, assign) NSInteger goodsAnswerId;

@property (nonatomic, assign) NSInteger isDelete;

@property (nonatomic, assign) NSInteger reportQty;

@property (nonatomic, assign) NSInteger rewardScore;

@property (nonatomic, assign) NSInteger totalAnswerQty;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger goodsUserId;

@property (nonatomic, copy) NSArray *tagList;

@end
