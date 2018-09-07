//
//  UnfoldTableCell.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "UnfoldTableCell.h"

@implementation UnfoldTableCell

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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = titleFont_15;
    _titleLabel.textColor =lgrayColor;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = bgColor;
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    _viewBaby = [[UIView alloc] init];
    _viewBaby.backgroundColor = bgColor;
    [self addSubview:_viewBaby];
    [_viewBaby mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@100);
    }];
    
    _commonLabel = [[UILabel alloc] init];
    _commonLabel.font = titleFont_15;
    _commonLabel.textColor =lgrayColor;
    [_viewBaby addSubview:_commonLabel];
    [_commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewBaby.mas_top).with.offset(10);
        make.left.equalTo(_viewBaby.mas_left).with.offset(10);
        make.right.equalTo(_viewBaby.mas_right).with.offset(-10);
        make.height.equalTo(@100);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
