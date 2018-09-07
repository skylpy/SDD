//
//  SDD_BasicInformation.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDD_BasicInformation : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic, strong)NSString *developName;
@property (nonatomic, strong)UITableView *tableView;

@property (assign,nonatomic)NSInteger page;

@end
