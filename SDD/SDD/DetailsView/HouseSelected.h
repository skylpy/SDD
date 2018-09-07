//
//  HouseSelected.h
//  SDD
//  在线选房
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseSelected : UIView

// 在线选房 往左
@property (nonatomic, strong) UIButton *onLeft;
// 在线选房 往右
@property (nonatomic, strong) UIButton *onRight;
// 在线选房 栋
@property (nonatomic, strong) UILabel *onlineBuilding;
// 在线选房 房号
@property (nonatomic, strong) UILabel *onlineRoomNumber;
// 在线选房 户型
@property (nonatomic, strong) UILabel *onlineDoorModel;
// 在线选房 面积m
@property (nonatomic, strong) UILabel *onlineArea;
// 在线选房 优惠价
@property (nonatomic, strong) UILabel *onlinePreferentialPrice;
// 在线选房 操作
@property (nonatomic, strong) UIButton *onlineOperation;

@end
