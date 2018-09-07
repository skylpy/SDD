//
//  JoinContactTableViewCell.h
//  SDD
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinContactTableViewCell : UITableViewCell

// 名
@property (nonatomic, strong) UILabel *peopleName;
// 职位
@property (nonatomic, strong) UILabel *peoplePosition;
// 地方
@property (nonatomic, strong) UILabel *peopleRegion;
// 固话
@property (nonatomic, strong) UILabel *peopleTel;
// 手机号
@property (nonatomic, strong) UILabel *peopleMobileNum;
// 邮箱
@property (nonatomic, strong) UILabel *peopleEmail;
// 地址
@property (nonatomic, strong) UILabel *peopleAddress;

@end
