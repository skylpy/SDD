//
//  NewPublishTableCell.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewPublishTableCell.h"

@implementation NewPublishTableCell

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
    _iconImage.backgroundColor = [UIColor orangeColor];
    _iconImage.layer.cornerRadius = 25;
    _iconImage.clipsToBounds = YES;
    [self addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo(_iconImage.mas_right).with.offset(20);
    }];
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.textColor = lgrayColor;
    _subtitleLabel.font = titleFont_15;
    [self addSubview:_subtitleLabel];
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(8);
        make.left.equalTo(_iconImage.mas_right).with.offset(20);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
