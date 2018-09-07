//
//  OnLineTableCell.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "OnLineTableCell.h"

@implementation OnLineTableCell

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
    _explainLabel = [[UILabel alloc] init];
    _explainLabel.text = @"在线填写项目资料";
    _explainLabel.textColor = lgrayColor;
    _explainLabel.font = titleFont_15;
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_explainLabel];
    
    [_explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    _OnLineBtn = [[UIButton alloc] init];
    [_OnLineBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [Tools_F setViewlayer:_OnLineBtn cornerRadius:5 borderWidth:0.5 borderColor:[UIColor orangeColor]];
    [self addSubview:_OnLineBtn];
    [_OnLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_explainLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.equalTo(@45);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
