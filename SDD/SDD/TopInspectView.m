//
//  TopInspectView.m
//  SDD
//
//  Created by mac on 16/1/6.
//  Copyright (c) 2016年 jofly. All rights reserved.
//

#import "TopInspectView.h"

@implementation TopInspectView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView{

    _topImage = [[UIImageView alloc] init];
    
    [self addSubview:_topImage];
    [_topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@140);
    }];
    
    
    _SponsorLable = [[UILabel alloc] init];
    _SponsorLable.textColor = lgrayColor;
    _SponsorLable.font = midFont;
    [self addSubview:_SponsorLable];
    [_SponsorLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topImage.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _AssistingLable = [[UILabel alloc] init];
    _AssistingLable.textColor = lgrayColor;
    _AssistingLable.font = midFont;
    [self addSubview:_AssistingLable];
    [_AssistingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_SponsorLable.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _ActivityTimeLable = [[UILabel alloc] init];
    _ActivityTimeLable.textColor = lgrayColor;
    _ActivityTimeLable.font = midFont;
    [self addSubview:_ActivityTimeLable];
    [_ActivityTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_AssistingLable.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _CollectionSiteLable = [[UILabel alloc] init];
    _CollectionSiteLable.textColor = lgrayColor;
    _CollectionSiteLable.font = midFont;
    [self addSubview:_CollectionSiteLable];
    [_CollectionSiteLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_ActivityTimeLable.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UILabel * linelabel = [[UILabel alloc] init];
    linelabel.backgroundColor = bgColor;
    [self addSubview:linelabel];
    [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_CollectionSiteLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    _icondImage = [[UIImageView alloc] init];
    
    [self addSubview:_icondImage];
    [_icondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(linelabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    _DeadlineLable = [[UILabel alloc] init];
    _DeadlineLable.textColor = lgrayColor;
    _DeadlineLable.font = bottomFont_12;
    [self addSubview:_DeadlineLable];
    [_DeadlineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(linelabel.mas_bottom).with.offset(5);
        make.left.equalTo(_icondImage.mas_right).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _iconsImage = [[UIImageView alloc] init];
    
    [self addSubview:_iconsImage];
    [_iconsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(linelabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-100);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    _SignUpLable = [[UILabel alloc] init];
    _SignUpLable.textColor = lgrayColor;
    _SignUpLable.font = bottomFont_12;
    [self addSubview:_SignUpLable];
    [_SignUpLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(linelabel.mas_bottom).with.offset(5);
        make.left.equalTo(_iconsImage.mas_right).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
