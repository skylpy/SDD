//
//  DDetailViewController.h
//  SDD
//  动态详情
//  Created by hua on 15/7/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryContentListModel.h"

@interface DDetailViewController : XHBaseViewController

@property (nonatomic, assign) NSInteger dynamicId;

@property (nonatomic,retain) CategoryContentListModel *model;

@property (nonatomic, strong) NSString *categoryTitle;

@end
