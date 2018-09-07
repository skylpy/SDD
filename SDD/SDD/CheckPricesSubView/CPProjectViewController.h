//
//  CPProjectViewController.h
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

/*
 项目名称搜索页面
 */

#import <UIKit/UIKit.h>

@interface CPProjectViewController : UIViewController

@property (nonatomic, strong) NSString *someText;
@property (nonatomic, strong) NSString *labelText;

@property (nonatomic, copy) void(^doTransferHouseName)(NSString *_houseName , NSString *_houseId);

@end
