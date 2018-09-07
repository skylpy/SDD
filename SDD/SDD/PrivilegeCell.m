//
//  PrivilegeCell.m
//  SDD
//
//  Created by mac on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PrivilegeCell.h"

@implementation PrivilegeCell

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
    self.contentView.frame = CGRectMake(0, 0, viewWidth, 150);
    
    _titLabel = [[UILabel alloc] init];
    _titLabel.text = @"优惠说明";
    _titLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titLabel];

    [_titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@20);
        //make.width.equalTo(@20);
    }];
    
    UIImageView * lineImageView = [[UIImageView alloc] init];
    lineImageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:lineImageView];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@20);
        //make.width.equalTo(@20);
    }];
    
    //WithFrame:CGRectMake(15/2, 50, 305, 100)
    _ContentLabel = [[UILabel alloc] init];
    _ContentLabel.numberOfLines = 0;
    _ContentLabel.font = [UIFont systemFontOfSize:13];
    [_ContentLabel setTextColor:[UIColor grayColor]];
    _ContentLabel.text = @"得分高低及京东IF奖东四附近的搜房第四isdjfodisjfdiosfjdos附近的搜附近哦获得健康活动卡大数据等哈说的哈开始打开速度哈师大送快递哈开始觉得哈萨克";
    [self addSubview:_ContentLabel];
    
    [_ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineImageView.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@20);
        //make.width.equalTo(@20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end