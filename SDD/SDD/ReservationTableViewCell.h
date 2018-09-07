//
//  ReservationTableViewCell.h
//  SDD
//
//  Created by hua on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationTableViewCell : UITableViewCell

@property (retain,nonatomic) UILabel *reservationTime;
@property (retain,nonatomic) UILabel *houseName;

@property (retain,nonatomic) UILabel *appointmentNum;
@property (retain,nonatomic) UILabel *discountContent;
@property (retain,nonatomic) ConfirmButton *rescheduleButton;

@property (retain,nonatomic) UIImageView * progressImage;

@property (retain,nonatomic) UIView *blackShadow;

@property (nonatomic, assign) BOOL isOutdated;

@property (retain,nonatomic) UILabel *topLabel;

@end
