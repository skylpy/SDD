//
//  ConsultantTableViewCell.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ConsultantTableViewCell.h"
//#import "Tools_F.h"

@implementation ConsultantTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 头像
        _avatar = [[UIImageView alloc] init];
        _avatar.frame = CGRectMake(5, 10, 50, 50);
        [Tools_F setViewlayer:_avatar cornerRadius:0 borderWidth:1 borderColor:bgColor];
        [self addSubview:_avatar];
        
        // 昵称
        _nickname = [[UILabel alloc] init];
        _nickname.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+10, 15, viewWidth/2.5, 15);
        _nickname.font = titleFont_15;
        [self addSubview:_nickname];
        
        // 评分
//        _starRate = [[CWStarRateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_avatar.frame)+10, CGRectGetMaxY(_nickname.frame)+5, 90, 15) numberOfStars:5];
//        _starRate.userInteractionEnabled = NO;    // 这里只作展示
//        _starRate.hasAnimation = YES;
//        [self addSubview:_starRate];
        
        // 评论内容
        _comment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatar.frame)+10, 70-15-13, viewWidth/3, 13)];
        _comment.font = midFont;
        _comment.textColor = lgrayColor;
        [self addSubview:_comment];
        
        // 打电话
        _makeCall = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeCall.frame = CGRectMake(viewWidth-130, 10, 50, 50);
        [_makeCall setBackgroundImage:[UIImage imageNamed:@"house_counselor_call1"] forState:UIControlStateNormal];
        [self addSubview:_makeCall];
        
//        UILabel *makeCallLabel = [[UILabel alloc] init];
//        makeCallLabel.frame = CGRectMake(viewWidth-100, CGRectGetMaxY(_makeCall.frame), 40, 13);
//        makeCallLabel.font = midFont;
//        makeCallLabel.text = @"打电话";
//        makeCallLabel.textColor = lgrayColor;
//        [self addSubview:makeCallLabel];
        
        // 在线咨询
        _makeContact = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeContact.frame = CGRectMake(viewWidth-65, 10, 50, 50);
        [_makeContact setBackgroundImage:[UIImage imageNamed:@"house_counselor_online1"] forState:UIControlStateNormal];
        [self addSubview:_makeContact];
        
//        UILabel *makeContact = [[UILabel alloc] init];
//        makeContact.frame = CGRectMake(viewWidth-57.5, CGRectGetMaxY(_makeCall.frame), 55, 13);
//        makeContact.font = midFont;
//        makeContact.text = @"在线咨询";
//        makeContact.textColor = lgrayColor;
//        [self addSubview:makeContact];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
