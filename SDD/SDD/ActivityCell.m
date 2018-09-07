//
//  ActivityCell.m
//  SDD
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

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
    _headImage = [[UIImageView alloc] init];
    _headImage.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_headImage];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@140);
    }];
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.font = titleFont_15;
    [self addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _addsLable = [[UILabel alloc] init];
    _addsLable.font = bottomFont_12;
    _addsLable.textColor = deepBLack;
    _addsLable.text =@"活动地址：";
    [self addSubview:_addsLable];
    [_addsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
    }];
    
    _addssssLable = [[UILabel alloc] init];
    _addssssLable.font = bottomFont_12;
    _addssssLable.textColor =[UIColor orangeColor];
    [self addSubview:_addssssLable];
    [_addssssLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLable.mas_bottom).with.offset(10);
        make.left.equalTo(_addsLable.mas_right).with.offset(0);
    }];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.font = bottomFont_12;
//    _timeLable.text = @"活动时间";
    [self addSubview:_timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addsLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _activityLable = [[UILabel alloc] init];
    _activityLable.font = bottomFont_12;
    _activityLable.textColor = lgrayColor;
    _activityLable.numberOfLines = 0;
    [self addSubview:_activityLable];
    [_activityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    //_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.titleLabel.font= largeFont ;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]
                    forState:UIControlStateNormal];
    [Tools_F setViewlayer:_button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    _button.tag = 1000;
    [_button setTitle:@"立即报名" forState:UIControlStateNormal];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.equalTo(@45);
    }];
    
    _invitationLable = [[UILabel alloc] init];
    _invitationLable.font = bottomFont_12;
    _invitationLable.textColor = lgrayColor;
    _invitationLable.numberOfLines = 0;
    _invitationLable.numberOfLines = 3;
//    bubbleText.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
    [self addSubview:_invitationLable];
    [_invitationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_activityLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.bottom.equalTo(_button.mas_top).with.offset(-5);
    }];

    _peopleLabel = [[UILabel alloc]init];
    _peopleLabel.font = bottomFont_12;
    _peopleLabel.textColor = lgrayColor;
    _peopleLabel.numberOfLines = 0;
//    _peopleLabel.text = @"参会人数：";
    [self addSubview:_peopleLabel];
    [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_invitationLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
//    ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 10, viewWidth-40, 45) title:nil target:self action:nil];
//    conBrandBtn.enabled = YES;
//    [self addSubview:conBrandBtn];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
