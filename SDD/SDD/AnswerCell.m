//
//  AnswerCell.m
//  SDD
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "AnswerCell.h"
//#import "AnswerLabel.h"

@implementation AnswerCell

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
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines= 0;
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        
    }];
    
    _answerLabel = [[AnswerLabel alloc] init];
    //_answerLabel.numberOfLines = 0;
    //_answerLabel.font = [UIFont systemFontOfSize:15];
    //_answerLabel.textColor = [UIColor b];
    
    _answerLabel.backgroundColor = [SDDColor colorWithHexString:@"#D9D9D9"];
    [self addSubview:_answerLabel];
    
    [_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        
    }];
    
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    [_timeLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_timeLabel];
//
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_answerLabel.mas_bottom).with.offset(7);
        make.left.equalTo(self.mas_left).with.offset(10);
        
    }];
    
    
    UIImageView * conImageView = [[UIImageView alloc] init];
    conImageView.image = [UIImage imageNamed:@"answer_icon"];
    [self addSubview:conImageView];
    
    [conImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_answerLabel.mas_bottom).with.offset(8);
        make.left.equalTo(_timeLabel.mas_left).with.offset(480/2);
        //make.right.equalTo(self.mas_right).with.offset(-50);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    
//    UIImageView * GoldCoinImageView = [[UIImageView alloc] init];
//    GoldCoinImageView.image = [UIImage imageNamed:@"gold_icon"];
//    [self addSubview:GoldCoinImageView];
//    
//    [GoldCoinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_answerLabel.mas_bottom).with.offset(8);
//        make.left.equalTo(_timeLabel.mas_left).with.offset(160);
//        //make.right.equalTo(self.mas_right).with.offset(-100);
//        make.height.equalTo(@20);
//        make.width.equalTo(@20);
//    }];
    
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = [UIColor grayColor];
    [self addSubview:_numLabel];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_answerLabel.mas_bottom).with.offset(10);
        make.left.equalTo(conImageView.mas_right).with.offset(8);
    }];
    
//    _CoinLabel = [[UILabel alloc] init];
//    _CoinLabel.font = [UIFont systemFontOfSize:13];
//    [self addSubview:_CoinLabel];
//    
//    [_CoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_answerLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(GoldCoinImageView.mas_left).with.offset(10);
//    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
