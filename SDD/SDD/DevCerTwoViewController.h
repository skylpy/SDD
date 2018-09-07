//
//  DevCerTwoViewController.h
//  SDD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface DevCerTwoViewController : XHBaseViewController

@property (retain,nonatomic)NSString * companyName;//公司名称
@property (retain,nonatomic)NSString * projectName;//项目名称

@property (retain,nonatomic)NSString * projectAdds;//项目地址
@property (retain,nonatomic)NSString * companyAdds;//公司地址

@property (retain,nonatomic)NSString * companyIntro;//公司简介

@property (retain,nonatomic) NSString * licenseImageStr; //营业执照
@property (retain,nonatomic) NSString * figureImageStr; //公司形象

@property (assign,nonatomic) NSInteger industryTypeId;//行业类型
@property (assign,nonatomic) NSInteger projectNatureId;//项目性质
@property (assign,nonatomic) NSInteger projectTypeId;//项目类型

@end
