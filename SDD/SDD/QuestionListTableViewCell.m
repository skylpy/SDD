//
//  QuestionListTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "QuestionListTableViewCell.h"

@implementation QuestionListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _theQuestion = [[UILabel alloc] init];
        _theQuestion.font = midFont;
        _theQuestion.numberOfLines = 0;
        [self addSubview:_theQuestion];
        
        // 回答背景
        _answer_bg = [[UIView alloc] init];
        _answer_bg.backgroundColor = bgColor;
        [self addSubview:_answer_bg];
        
        _theAnswer = [[UILabel alloc] init];
        _theAnswer.font = midFont;
        _theAnswer.textColor = lgrayColor;
//        _theAnswe
        _theAnswer.numberOfLines = 3;
        [_answer_bg addSubview:_theAnswer];
        
        UIImageView *tagImageView = [[UIImageView alloc] init];
        tagImageView.image = [UIImage imageNamed:@"label_icon"];
        [self addSubview:tagImageView];
        
        _theTags = [[UILabel alloc] init];
        _theTags.font = littleFont;
        _theTags.textColor = lorangeColor;
        [self addSubview:_theTags];
        
        _theAnswerQty = [UIButton buttonWithType:UIButtonTypeCustom];
        _theAnswerQty.titleLabel.font = littleFont;
        [_theAnswerQty setTitleColor:lgrayColor forState:UIControlStateNormal];
        [_theAnswerQty setImage:[UIImage imageNamed:@"answer_icon"] forState:UIControlStateNormal];
        _theAnswerQty.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _theAnswerQty.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:_theAnswerQty];
        
        [_theQuestion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.greaterThanOrEqualTo(@13);
        }];
        
        [_answer_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theQuestion.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(@0);
        }];
        
        [_theAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 10));
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        [_theTags mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagImageView.mas_right);
            make.right.equalTo(_theAnswerQty.mas_left).with.offset(-10);
            make.height.equalTo(@10);
            make.centerY.equalTo(tagImageView);
        }];

        [_theAnswerQty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 15));
            make.centerY.equalTo(tagImageView);
        }];
    }
    return self;
}

- (void)setHaveBestAnswer:(BOOL)haveBestAnswer {
    
    if (haveBestAnswer) {
        
        [_answer_bg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theQuestion.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.greaterThanOrEqualTo(@13);
        }];
        
        [_theAnswer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_answer_bg).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    }
    else {
        
        [_theAnswer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        [_answer_bg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
