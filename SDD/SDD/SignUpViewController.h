//
//  SignUpViewController.h
//  SDD
//
//  Created by mac on 16/1/7.
//  Copyright (c) 2016年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"
#import "ActivityNModel.h"

@interface SignUpViewController : XHBaseViewController
@property (retain,nonatomic)NSDictionary * temDic;
@property (assign,nonatomic)int actNum;

//新传值
@property (retain,nonatomic)NSString * confromTimespStr;
@property (retain,nonatomic)NSString * str2;
@property (retain,nonatomic)NSString * str1;


@property (retain,nonatomic)NSString * str4;
@property (retain,nonatomic)NSString * strname;
@property (retain,nonatomic)NSString * indStr;
@property (retain,nonatomic)NSString * brandStr;

@property (retain,nonatomic)ActivityNModel * model ;

@property (retain,nonatomic)NSNumber * activityId;
@property (retain,nonatomic)NSString * titles;
@property (retain,nonatomic)NSNumber * activityTime;
@end
