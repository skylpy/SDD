//
//  NewJoinDatailBrandViewController.h
//  SDD
//
//  Created by mac on 15/12/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface NewJoinDatailBrandViewController : XHBaseViewController

// 品牌id
@property (nonatomic, strong) NSString *brandId;

// 临时用来判断是否推荐品牌
@property (nonatomic, assign) NSInteger brandType;

@end
