//
//  InvestmentTWOViewController.h
//  SDD
//
//  Created by mac on 15/10/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface InvestmentTWOViewController : XHBaseViewController

// 品牌id
@property (nonatomic, strong) NSString *brandId;

@property (nonatomic, strong)NSString * positionStr;//职务
@property (nonatomic, strong)NSString * phoneStr; //电话
@property (nonatomic, strong)NSString * contactStr; //联系人
@property (nonatomic, strong)NSString * departmentStr; //部门
@property (nonatomic, strong)NSString * codeStr;//验证码

@property (nonatomic, assign)NSInteger  postCategoryId;//职务

@end
