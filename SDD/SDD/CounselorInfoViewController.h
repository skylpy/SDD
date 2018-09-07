//
//  CounselorInfoViewController.h
//  SDD
//  团购、团租、房源 -> 顾问信息
//  Created by hua on 15/4/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface CounselorInfoViewController : XHBaseViewController

// 房子id
@property (nonatomic, strong) NSString *houseID;
// 用户id
@property (nonatomic, strong) NSString *userID;
// 手机号
@property (nonatomic, strong) NSString *phone;


@end
