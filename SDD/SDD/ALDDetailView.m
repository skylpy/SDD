//
//  ALDDetailView.m
//  SDD
//
//  Created by hua on 15/4/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ALDDetailView.h"
#import "Tools_F.h"

@implementation ALDDetailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 头像
        _avatar = [[UIImageView alloc] init];
        _avatar.frame = CGRectMake(5, 10, 40, 40);
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 20;
        _avatar.backgroundColor = lgrayColor;
        [self addSubview:_avatar];
        
        // 身份
        _identity = [[UILabel alloc] init];
        _identity.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+10, 10, viewWidth/3, 16);
        _identity.font = [UIFont systemFontOfSize:16];
        _identity.textColor = lgrayColor;
        [self addSubview:_identity];
        
        // 名称
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatar.frame)+10, CGRectGetMaxY(_identity.frame)+8, viewWidth/3, 15)];
        _name.font = [UIFont systemFontOfSize:13];
        _name.textColor = lgrayColor;
        [self addSubview:_name];

        // 打电话
        _makeCall = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeCall.frame = CGRectMake(viewWidth-100, 5, 40, 40);
        [_makeCall setBackgroundImage:[UIImage imageNamed:@"index_btnbg_call_white"] forState:UIControlStateNormal];
        [self addSubview:_makeCall];
        
        UILabel *makeCallLabel = [[UILabel alloc] init];
        makeCallLabel.frame = CGRectMake(viewWidth-100, CGRectGetMaxY(_makeCall.frame), 40, 13);
        makeCallLabel.font = midFont;
        makeCallLabel.text = @"打电话";
        makeCallLabel.textColor = lgrayColor;
        [self addSubview:makeCallLabel];
        
        // 在线咨询
        _makeContact = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeContact.frame = CGRectMake(viewWidth-50, 5, 40, 40);
        [_makeContact setBackgroundImage:[UIImage imageNamed:@"index_btnbg_chat_white"] forState:UIControlStateNormal];
        [self addSubview:_makeContact];
        
        UILabel *makeContact = [[UILabel alloc] init];
        makeContact.frame = CGRectMake(viewWidth-57.5, CGRectGetMaxY(_makeCall.frame), 55, 13);
        makeContact.font = midFont;
        makeContact.text = @"在线咨询";
        makeContact.textColor = lgrayColor;
        [self addSubview:makeContact];

    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
