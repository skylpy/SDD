//
//  DynamicListTableViewCell.h
//  SDD
//
//  Created by hua on 15/7/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicListTableViewCell : UITableViewCell

// 图片
@property (nonatomic, strong) UIImageView *listImage;
// 地名
@property (nonatomic, strong) UILabel *listTitle;
// 户型
@property (nonatomic, strong) UILabel *listSummary;

@end
