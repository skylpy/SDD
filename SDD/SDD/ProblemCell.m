//
//  ProblemCell.m
//  SDD
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProblemCell.h"

@implementation ProblemCell

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
    self.contentView.frame = CGRectMake(0, 0, viewWidth, 282/2);
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines= 0;
    [self addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        
    }];
    

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    [_timeLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        
    }];
    
    UIImageView * conImageView = [[UIImageView alloc] init];
    conImageView.image = [UIImage imageNamed:@"answer_icon"];
    [self addSubview:conImageView];
    
    [conImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).with.offset(20);
        //make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-30);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = [UIColor grayColor];
    [self addSubview:_numLabel];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).with.offset(20);
        //make.left.equalTo(self.mas_left).with.offset(10);
        make.left.equalTo(conImageView.mas_right).with.offset(8);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    
    _redLabel = [[UILabel alloc] init];
    _redLabel.font = [UIFont systemFontOfSize:13];
    _redLabel.backgroundColor = [UIColor redColor];
    _redLabel.textColor = [UIColor whiteColor];
    _redLabel.textAlignment = NSTextAlignmentCenter;
    _redLabel.layer.cornerRadius = 10;
    _redLabel.clipsToBounds = YES;
    [self addSubview:_redLabel];
    
    [_redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).with.offset(20);
        //make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(conImageView.mas_left).with.offset(-10);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
