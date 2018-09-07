//
//  SDD_ItemDetail.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDD_ItemDetail : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

//第一个界面的数据
@property (retain,nonatomic)NSMutableArray * BasicArray;

//时间选择器
@property (retain,nonatomic) NSMutableArray * proYearsList;
@property (retain,nonatomic) NSMutableArray * proMonthList;
@property (retain,nonatomic) NSMutableArray * proDayList;
@property (retain,nonatomic) NSString * proYearsStr;
@property (retain,nonatomic) NSString * proMonthStr;
@property (retain,nonatomic) NSString * proDayStr;

@property (retain,nonatomic) UIView * TranSparentView;
@property (retain,nonatomic) UIView * SmallView;

@end
