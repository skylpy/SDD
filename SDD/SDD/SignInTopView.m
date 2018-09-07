//
//  SignInTopView.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SignInTopView.h"

@implementation SignInTopView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _IntegralRules = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, 20)];
    _IntegralRules.font = titleFont_15;
    
    [self addSubview:_IntegralRules];
    
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_IntegralRules.frame)+10, viewWidth, 1)];
    _lineLabel.backgroundColor = lgrayColor;
    
    [self addSubview:_lineLabel];
    
    _textLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, CGRectGetMaxY(_lineLabel.frame)+10, viewWidth-20, 130)
    _textLabel.textColor = lgrayColor;
    _textLabel.numberOfLines = 0;
    _textLabel.font = midFont;
    [self addSubview:_textLabel];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_lineLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(10);
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
