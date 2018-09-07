//
//  MyIsuuePCell.h
//  SDD
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIsuuePCell : UITableViewCell

@property (retain,nonatomic)UIImageView * iconImage;
@property (retain,nonatomic)UILabel * titleLabel;
@property (retain,nonatomic)UILabel * IsuueTimeLabel;
@property (retain,nonatomic)UILabel * statusLabel;

@property (retain,nonatomic)UIButton * statusBtn;
@property (retain,nonatomic)UIButton * PhoneBtn;

@end
