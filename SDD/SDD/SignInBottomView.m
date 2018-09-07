//
//  SignInBottomView.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SignInBottomView.h"

@implementation SignInBottomView

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
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
