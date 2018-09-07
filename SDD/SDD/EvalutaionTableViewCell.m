//
//  EvalutaionTableViewCell.m
//  商多多
//
//  Created by hua on 15/4/8.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EvalutaionTableViewCell.h"

@implementation EvalutaionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 头像
        _avatar = [[UIImageView alloc] init];
        _avatar.frame = CGRectMake(10, 10, 40, 40);
        [Tools_F setViewlayer:_avatar cornerRadius:0 borderWidth:1 borderColor:bgColor];
        [self addSubview:_avatar];
        
        // 昵称
        _nickname = [[UILabel alloc] init];
        _nickname.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+10, 10, viewWidth-70, 15);
        _nickname.font = titleFont_15;
        [self addSubview:_nickname];
        
        // 评分
        _starRate = [[CWStarRateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_avatar.frame)+10, CGRectGetMaxY(_nickname.frame)+5, 100, 15) numberOfStars:5];
        _starRate.userInteractionEnabled = NO;    // 这里只作展示
        _starRate.hasAnimation = YES;
        _starRate.scorePercent = 0;
        [self addSubview:_starRate];
        
        
    }
    return self;
}

- (void)setUserType:(int)userType{
    
    switch (userType) {
        case 0:
        {
            // 评论内容
            _comment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_avatar.frame)+10, viewWidth-20, 50)];
            _comment.font = midFont;
            _comment.textColor = lgrayColor;
            _comment.numberOfLines = 0;
            _comment.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;  // 最顶
            [self addSubview:_comment];
        }
            break;
        case 1:
        {
            // 评论内容
            _comment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_avatar.frame)+10, viewWidth-20, 50)];
            _comment.font = midFont;
            _comment.textColor = lgrayColor;
            _comment.numberOfLines = 0;
            _comment.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;  // 最顶
            [self addSubview:_comment];
            
            // 时间
            _commentTime = [[UILabel alloc] init];
            _commentTime.frame = CGRectMake(10, CGRectGetMaxY(_comment.frame), viewWidth-20, 12);
            _commentTime.font = bottomFont_12;
            _commentTime.textColor = lblueColor;
            [self addSubview:_commentTime];
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
