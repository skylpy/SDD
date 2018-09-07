//
//  ActivityTableCell.m
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityTableCell.h"

@implementation ActivityTableCell

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
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@150);
    }];
    
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"act-tip-rigsting"];
    [_headImage addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_top).with.offset(0);
        make.left.equalTo(_headImage.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.font = titleFont_15;
    [self addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
  
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = bgColor;
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    _timeImage = [[UIImageView alloc] init];
    _timeImage.image = [UIImage imageNamed:@"icon-act-time"];
    [self addSubview:_timeImage];
    [_timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lineLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        //make.right.equalTo(self.mas_right).with.offset();
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
  
    _timeLable = [[UILabel alloc] init];
    _timeLable.font = midFont;
    _timeLable.textColor = tagsColor;
    [self addSubview:_timeLable];
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lineLabel.mas_bottom).with.offset(8);
        make.left.equalTo(_timeImage.mas_right).with.offset(10);

    }];
    
    _addressLable = [[UILabel alloc] init];
    _addressLable.font = midFont;
    _addressLable.textColor = lgrayColor;
    [self addSubview:_addressLable];
    [_addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lineLabel.mas_bottom).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-10);

    }];
    
    _addressImage = [[UIImageView alloc] init];
    _addressImage.image = [UIImage imageNamed:@"icon-act-location"];
    [self addSubview:_addressImage];
    [_addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_lineLabel.mas_bottom).with.offset(8);
        make.right.equalTo(_addressLable.mas_left).with.offset(-10);
        
    }];
    
    _invitationLable = [[UILabel alloc] init];
    _invitationLable.font = midFont;
    _invitationLable.textColor = lgrayColor;
    _invitationLable.numberOfLines = 0;
    [self addSubview:_invitationLable];
    [_invitationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_timeLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(10);
        make.height.equalTo(@40);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
