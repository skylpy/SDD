//
//  JoinInNewViewController.h
//  SDD
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface JoinInNewViewController : XHBaseViewController

@property (nonatomic, strong) NSNumber *industryCategoryId;

// 临时用来判断是否推荐品牌
@property (nonatomic, assign) NSInteger brandType;

@end
