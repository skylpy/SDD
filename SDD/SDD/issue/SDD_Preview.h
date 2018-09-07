//
//  SDD_Preview.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPublicBean.h"
#import "XHBaseViewController.h"

@interface SDD_Preview : XHBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (retain,nonatomic)NSMutableArray * BasicArray;//第一界面数组
@property (retain,nonatomic)NSMutableArray * DetailsArray;//第二界面数组

@property (retain,nonatomic)NSMutableArray * MorePagesArray;//更多界面数组

@property (retain,nonatomic)NSMutableArray * UploadDataArray;//上传界面数组

@property (retain,nonatomic)MyPublicBean * model;

@property (assign,nonatomic)NSInteger houseFirstId;

@end
