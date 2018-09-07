//
//  SDD_MyIssueViewController.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface SDD_MyIssueViewController : XHBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@end
