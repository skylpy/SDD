//
//  CPTowardsViewController.h
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

/*
 朝向页面
 */

#import <UIKit/UIKit.h>

@interface CPTowardsViewController : UIViewController

@property (nonatomic, strong) NSString *someText;
@property (nonatomic, strong) NSString *labelText;

@property (nonatomic, copy) void(^doTransferMeg)(NSString *_meg, NSInteger _towardsId);

@end
