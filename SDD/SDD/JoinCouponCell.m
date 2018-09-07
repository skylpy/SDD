//
//  JoinCouponCell.m
//  SDD
//
//  Created by mac on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinCouponCell.h"

@implementation JoinCouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
//创建视图
-(void)createView
{
    self.contentView.frame = CGRectMake(0, 0, viewWidth, 100);
    
    _bobyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, 150/2)];
    _bobyImageView.image = [UIImage imageNamed:@"source_big_frame"];
    [self addSubview:_bobyImageView];
    
    _HeadImageView = [[UIImageView alloc] init];
    //_HeadImageView.backgroundColor = [UIColor redColor];
    _HeadImageView.layer.cornerRadius = 25;
    _HeadImageView.clipsToBounds = YES;
    [_bobyImageView addSubview:_HeadImageView];
    
    [_HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(_bobyImageView.mas_left).with.offset(10);
        //make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    _FootImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150/2, viewWidth-20, 25)];
    _FootImageView.image = [UIImage imageNamed:@"date_frame"];
    [self addSubview:_FootImageView];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];
    leftImageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:leftImageView];
    
    UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-10, 0, 10, 100)];
    rightImageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:rightImageView];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.text = @"哈哈哈";
    _nameLable.font = [UIFont systemFontOfSize:15];
    [_nameLable setTextColor:[UIColor whiteColor]];
    [_bobyImageView addSubview:_nameLable];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(25);
        make.left.equalTo(_HeadImageView.mas_right).with.offset(15);
        //make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    
    _DiscountLable = [[UILabel alloc] init];
    //_DiscountLable.text = @"8.8折";
    [_DiscountLable setTextColor:[UIColor whiteColor]];
    [_bobyImageView addSubview:_DiscountLable];
    
    [_DiscountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        //make.left.equalTo(_HeadImageView.mas_right).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-13);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    
    _EffectiveLabel = [[UILabel alloc] init];
    _EffectiveLabel.text = @"有效期至2015-7-22";
    [_EffectiveLabel setTextColor:[UIColor grayColor]];
    _EffectiveLabel.font = [UIFont systemFontOfSize:13];
    [_FootImageView addSubview:_EffectiveLabel];
    
    
    [_EffectiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_FootImageView.mas_top).with.offset(3);
        //make.left.equalTo(_HeadImageView.mas_right).with.offset(15);
        make.left.equalTo(_FootImageView.mas_left).with.offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@150);
    }];
    
    _useImageView = [[UIImageView alloc] initWithFrame:CGRectMake(420/2, 16/2, 170/2, 170/2)];
    _useImageView.image = [UIImage imageNamed:@"use_icon"];
    [self addSubview:_useImageView];
    
    _overdueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(420/2, 16/2, 170/2, 170/2)];
    _overdueImageView.image = [UIImage imageNamed:@"expired_icon"];
    [self addSubview:_overdueImageView];
    
//    [_bobyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(0);
//        make.left.equalTo(self.mas_left).with.offset(10);
//        make.bottom.equalTo(self.mas_bottom).with.offset(25);
//        make.width.equalTo(@300);
//        make.height.equalTo(@100);
//    }];
    
//    [_HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bobyImageView.mas_top).with.offset(15);
//        make.left.equalTo(_bobyImageView.mas_left).with.offset(10);
//        make.bottom.equalTo(_bobyImageView.mas_bottom).with.offset(15);
//        make.width.equalTo(@50);
//    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
