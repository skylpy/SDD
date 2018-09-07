//
//  MyAppointmentCell.m
//  SDD
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyAppointmentCell.h"

@implementation MyAppointmentCell

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
    UIImageView * topImageView = [[UIImageView alloc] init];
    topImageView.backgroundColor = bgColor;
    [self addSubview:topImageView];
    
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@55);
    }];
    
    
    
    
    UIImageView * timeImageView = [[UIImageView alloc] init];
    //timeImageView.backgroundColor = [UIColor redColor];
    timeImageView.image = [UIImage imageNamed:@"iconfont_rili@2x"];
    [topImageView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_top).with.offset(30);
        make.left.equalTo(topImageView.mas_left).with.offset(10);
        //make.right.equalTo(topImageView.mas_left).with.offset(30);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    //_timeLabel.font = titleFont_15;
    [topImageView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_top).with.offset(30);
        make.left.equalTo(timeImageView.mas_right).with.offset(10);
        make.right.equalTo(topImageView.mas_right).with.offset(-10);
    }];
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.font = titleFont_15;
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UILabel * lineLable = [[UILabel alloc] init];
    lineLable.backgroundColor = bgColor;
    [self addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    _AppointmentLable = [[UILabel alloc] init];
    _AppointmentLable.font = midFont;
    [self addSubview:_AppointmentLable];
    [_AppointmentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLable.mas_top).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _DiscountLable = [[UILabel alloc] init];
    _DiscountLable.font = midFont;
    _DiscountLable.textColor = dblueColor;
    [self addSubview:_DiscountLable];
    [_DiscountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_AppointmentLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _bgCellView = [[UIView alloc] init];
    _bgCellView.alpha = 0.9;
    _bgCellView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgCellView];
    [_bgCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@180);
    }];
    
#pragma mark -- 预约失效的状态
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font= largeFont ;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]
                      forState:UIControlStateNormal];
    [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    button.tag = 1000;
    [button setTitle:@"重新报名" forState:UIControlStateNormal];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];
    
    _lineLable1 = [[UILabel alloc] init];
    _lineLable1.backgroundColor = bgColor;
    
    [self addSubview:_lineLable1];
    [_lineLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.mas_top).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    _PromptLabel = [[UILabel alloc] init];
    _PromptLabel.textColor = [UIColor orangeColor];
    _PromptLabel.font = [UIFont systemFontOfSize:20];
    _PromptLabel.text = @"预约已失效";
    _PromptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_PromptLabel];
    [_PromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom).with.offset(30);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.width.equalTo(@(viewWidth-40));
    }];
    
    _ParsingLabel = [[UILabel alloc] init];
    _ParsingLabel.textColor = lgrayColor;
    _ParsingLabel.font = titleFont_15;
    _ParsingLabel.text = @"预约时间已到期，点击重新预约时间";
    _ParsingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_ParsingLabel];
    [_ParsingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PromptLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.width.equalTo(@(viewWidth-40));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
