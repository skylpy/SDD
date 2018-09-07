//
//  FullScreenViewController.h
//  SDD
//  相册
//  Created by hua on 15/4/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenViewController : UIViewController

// 图片来源 0: 来自团购团租房源 1: 来自加盟商
@property (nonatomic, assign) NSInteger imagesFrom;
// 房子id
@property (nonatomic, strong) NSString *paramID;
// 跳某栏目
@property (nonatomic, strong) NSString *jumpColumn;

// 去某图
@property (nonatomic, strong) NSArray *theValue;

@end
