//
//  QuestionAndAnswerTableViewCell.m
//  SDD
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "QuestionAndAnswerTableViewCell.h"

@implementation QuestionAndAnswerTableViewCell

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
    
    //头像
    _HeadImageView = [[UIImageView alloc] init];
    _HeadImageView.layer.cornerRadius = 17;
    _HeadImageView.clipsToBounds = YES;
    [self addSubview:_HeadImageView];
    
    [_HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    //用户名
    _nameLabel = [[UILabel alloc] init];
    [self addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(_HeadImageView.mas_right).with.offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@15);
    }];
    
    //评论
    _comLabel = [[UILabel alloc] init];
    _comLabel.font = [UIFont systemFontOfSize:15];
    _comLabel.numberOfLines = 0;
    [self addSubview:_comLabel];
    
    [_comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_HeadImageView.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@15);
    }];
    
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        //make.right.equalTo(self.mas_right).with.offset(-80);
        //make.height.equalTo(@15);
    }];
    
    
    //评论标志
    _coinImageView = [[UIImageView alloc] init];
    _coinImageView.image = [UIImage imageNamed:@"answer_icon"];
    [self addSubview:_coinImageView];
    
    [_coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-40);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    //评论数量
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = [UIColor grayColor];
    [self addSubview:_numLabel];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(8);
        make.left.equalTo(_coinImageView.mas_right).with.offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
