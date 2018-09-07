//
//  SDD_MoreInfomation.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDD_UpLoadData.h"
//@protocol SDD_UpLoadDatadelegate;

@interface SDD_MoreInfomation : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

//时间选择器
@property (retain,nonatomic) NSMutableArray * proYearsList;
@property (retain,nonatomic) NSMutableArray * proMonthList;
@property (retain,nonatomic) NSMutableArray * proDayList;
@property (retain,nonatomic) NSString * proYearsStr;
@property (retain,nonatomic) NSString * proMonthStr;
@property (retain,nonatomic) NSString * proDayStr;

//设置代理反向传值
@property (retain,nonatomic)SDD_UpLoadData * delegate;
//@property( assign, nonatomic ) id< SDD_UpLoadDatadelegate >  delegate;

//第一个界面的数组
@property (retain,nonatomic)NSMutableArray * BasicArray;

//第二个界面的数组
@property (retain,nonatomic)NSMutableArray * DetailsArray;

////第三个界面
//@property (retain,nonatomic)NSMutableArray * FirstGroupArray;
//@property (retain,nonatomic)NSMutableArray * SecondGroupArray;
//@property (retain,nonatomic)NSMutableArray * ThirdGroupArray;
@property (retain,nonatomic)NSMutableArray * UploadDataArray;//上传界面数组

@end
