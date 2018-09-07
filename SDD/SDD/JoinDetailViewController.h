//
//  JoinDetailViewController.h
//  SDD
//  （全部）品牌商详情
//  Created by hua on 15/6/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface JoinDetailViewController : XHBaseViewController

// 品牌id
@property (nonatomic, strong) NSString *brandId;

// 临时用来判断是否推荐品牌
@property (nonatomic, assign) NSInteger brandType;

@end
