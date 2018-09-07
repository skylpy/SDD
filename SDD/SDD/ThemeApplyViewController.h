//
//  ThemeApplyViewController.h
//  SDD
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityNModel.h"

@interface ThemeApplyViewController : UIViewController

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
