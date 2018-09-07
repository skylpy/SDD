//
//  SDD_DeveloperList.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface SDD_DeveloperList : XHBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic)NSInteger page;

@end
