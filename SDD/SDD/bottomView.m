//
//  bottomView.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "bottomView.h"

@implementation bottomView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _freeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _freeBtn.frame = CGRectMake(0, 0, viewWidth/5*3, 50);
    _freeBtn.backgroundColor = [UIColor whiteColor];
    _freeBtn.titleLabel.font = midFont;
    _freeBtn.enabled = NO;
    [_freeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_freeBtn];
    
    _ExpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _ExpBtn.frame = CGRectMake(CGRectGetMaxX(_freeBtn.frame), 0, viewWidth/5*2, 50);
    [_ExpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ExpBtn.backgroundColor = tagsColor;
    _ExpBtn.titleLabel.font = titleFont_15;
    [self addSubview:_ExpBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
