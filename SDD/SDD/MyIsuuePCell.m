//
//  MyIsuuePCell.m
//  SDD
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyIsuuePCell.h"

@implementation MyIsuuePCell

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

-(void)createView
{
    _iconImage = [[UIImageView alloc] init];
    
    [self addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(@105);
        make.height.equalTo(@80);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(_iconImage.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _IsuueTimeLabel = [[UILabel alloc] init];
    _IsuueTimeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_IsuueTimeLabel];
    [_IsuueTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(_iconImage.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = bgColor;
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImage.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    _statusBtn = [[UIButton alloc] init];
    [_statusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:_statusBtn];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineLabel.mas_bottom).with.offset(-10);
        make.left.equalTo(_iconImage.mas_right).with.offset(10);
        //make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    
    _PhoneBtn = [[UIButton alloc] init];
    _PhoneBtn.backgroundColor = dblueColor;
    _PhoneBtn.layer.cornerRadius = 5;
    _PhoneBtn.clipsToBounds = YES;
    [_PhoneBtn setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    [self addSubview:_PhoneBtn];
    [_PhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom).with.offset(6);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = dblueColor;
    _statusLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(_PhoneBtn.mas_left).with.offset(-10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
