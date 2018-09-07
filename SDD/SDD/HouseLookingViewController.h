//
//  HouseLookingViewController.h
//  SDD
//  看房团
//  Created by hua on 15/4/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseLookingViewController : XHBaseViewController

// 看房id
@property (nonatomic, strong) NSString *houseShowingsId;
// 看房标题
@property (nonatomic, strong) NSString *hkTitle;
// 已报名
@property (nonatomic, assign) BOOL isApply;

@end
