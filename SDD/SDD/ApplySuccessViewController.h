//
//  ApplySuccessViewController.h
//  SDD
//  看房团申请成功页
//  Created by hua on 15/4/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplySuccessViewController : XHBaseViewController

// 标题
@property (nonatomic, strong) NSString *hkTitle;
// 信息内容
@property (nonatomic, strong) NSArray *hkInfo;
// 房子id
@property (nonatomic, strong) NSString *houseID;

@end
