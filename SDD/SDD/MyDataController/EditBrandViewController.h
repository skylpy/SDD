//
//  EditBrandViewController.h
//  SDD
//  品牌修改
//  Created by hua on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface EditBrandViewController : XHBaseViewController

// 用户名
@property (nonatomic, strong) NSString *theBrandname;
// block
typedef void(^ReturnBrandname) (NSString *theBrandname);

@property (nonatomic, copy) ReturnBrandname returnBlock;
- (void)valueReturn:(ReturnBrandname)block;

@property (retain,nonatomic)NSString * NvcName;
@end
