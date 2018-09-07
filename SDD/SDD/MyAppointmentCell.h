//
//  MyAppointmentCell.h
//  SDD
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAppointmentCell : UITableViewCell

@property (retain,nonatomic)UILabel * timeLabel;
@property (retain,nonatomic)UILabel * titleLable;

@property (retain,nonatomic)UILabel * AppointmentLable;
@property (retain,nonatomic)UILabel * DiscountLable;
@property (retain,nonatomic)UIView * bgCellView;


#pragma mark -- 第二种状态
@property (retain,nonatomic)UILabel * lineLable1;
@property (retain,nonatomic)UILabel * PromptLabel;
@property (retain,nonatomic)UILabel * ParsingLabel;

@end
