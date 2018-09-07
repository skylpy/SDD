//
//  MyQuestionsViewController.h
//  问答的详情
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicAnswerModel.h"
#import "XHBaseViewController.h"

@interface MyQuestionsViewController : XHBaseViewController

@property (retain,nonatomic) DynamicAnswerModel * model;

@property (assign,nonatomic) int questionsId;

@property (assign,nonatomic) NSUInteger userId;

@end
