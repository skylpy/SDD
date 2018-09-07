//
//  HouseDynamicTableViewCell.h
//  SDD
//
//  Created by hua on 15/4/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDynamicTableViewCell : UITableViewCell

// 动态标题
@property (nonatomic, strong) UILabel *theTitle;
// 动态内容
@property (nonatomic, strong) UILabel *theContent;
// 时间
@property (nonatomic, strong) UILabel *theTime;
// 打开
@property (nonatomic, strong) UIButton *openDynamic;

@end
