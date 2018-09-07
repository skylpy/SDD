//
//  ActivityTableCell.h
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableCell : UITableViewCell

@property (retain,nonatomic)UIImageView * headImage;
@property (retain,nonatomic)UILabel * titleLable;
@property (retain,nonatomic)UILabel * lineLabel;
@property (retain,nonatomic)UIImageView * timeImage;
@property (retain,nonatomic)UILabel * timeLable;
@property (retain,nonatomic)UIImageView *addressImage;
@property (retain,nonatomic)UILabel * addressLable;
@property (retain,nonatomic)UILabel * invitationLable;

@property (retain,nonatomic)UIImageView * iconImage;

@end
