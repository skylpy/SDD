//
//  JoinWithCompanyInfoViewController.h
//  SDD
//
//  Created by hua on 15/12/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinWithCompanyInfoViewController : XHBaseViewController

// 品牌id
@property (nonatomic, strong) NSString *brandId;
// 品牌名
@property (nonatomic, strong) NSString *brandStr;
// 折扣
@property (nonatomic, strong) NSString *discount;

@property(nonatomic,copy) NSString *name;  //姓名
@property(nonatomic,assign) NSInteger sex;  //性别
@property(nonatomic,assign) NSInteger phoneNumber;  //手机号

@end
