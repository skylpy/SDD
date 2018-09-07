//
//  PreferentialJoinDetailMoreViewController.h
//  SDD
//
//  Created by hua on 15/12/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@class FranchiseesDetailModel;

@interface PreferentialJoinDetailMoreViewController : XHBaseViewController

// 品牌id
@property (nonatomic, strong) NSString *brandId;

// 临时用来判断是否推荐品牌
@property (nonatomic, assign) NSInteger brandType;


@end
