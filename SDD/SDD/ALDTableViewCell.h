//
//  ALDTableViewCell.h
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALDTableViewCell : UITableViewCell

// 户型图片
@property (nonatomic, strong) UIImageView *imgView;
// 户型
@property (nonatomic, strong) UILabel *houseType;
// 面积
@property (nonatomic, strong) UILabel *houseSize;
// 业态
@property (nonatomic, strong) UILabel *houseIndustry;

@end
