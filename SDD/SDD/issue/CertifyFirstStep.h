//
//  CertifyFirstStep.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertifyFirstStep : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString       *companyName;//公司名称
@property (nonatomic,strong) NSString       *hoseName;//项目名称

@property (nonatomic,assign) NSInteger      *industryCategoryId;//行业
@property (nonatomic,assign) NSInteger      *typeCategoryId;//性质
@property (nonatomic,assign) NSInteger      *projectNatureCategoryId;//类别


@property (nonatomic,strong) NSString       *hoseAdress;//项目地址
@property (nonatomic,strong) NSString       *companyAdress;//公司地址
@property (nonatomic,strong) NSString       *companyDescription;//公司描述

@property (nonatomic,strong) NSString       *businessLicense;//营业执照url
@property (nonatomic,strong) NSString       *companyImage;//公司名片



@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *certiyFirstArr;

@property (assign,nonatomic)NSInteger page;//判断哪里进来的

@end
