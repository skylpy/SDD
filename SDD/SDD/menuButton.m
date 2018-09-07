//
//  menuButton.m
//  SDD
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "menuButton.h"

@implementation menuButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // icon
        _icon = [[UIButton alloc] init];
        _icon.frame = CGRectMake(self.frame.size.width-20, self.frame.size.height-25, 10, 8);
        //_icon.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/3+4);
        [self addSubview:_icon];
        
        // 小标题
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, 12, self.frame.size.width-25, 15);
        [_bottomBtn setTitleColor:lgrayColor forState:UIControlStateNormal]; ;
        //[_bottomLabel setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _bottomBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _bottomBtn.titleLabel.font = titleFont_15;
        [self addSubview:_bottomBtn];
        
        UILabel * lineLable = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-1, 5, 1, self.frame.size.height-10)];
        lineLable.backgroundColor = bgColor;
        [self addSubview:lineLable];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1,self.frame.size.width, 1)];
        line.backgroundColor = bgColor;
        [self addSubview:line];
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
