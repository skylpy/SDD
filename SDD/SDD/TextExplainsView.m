//
//  TextExplainsView.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "TextExplainsView.h"

@implementation TextExplainsView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, 20)];
        _titleLable.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:_titleLable];
        
        _lineLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLable.frame)+10, viewWidth-20, 1)];
        _lineLable.backgroundColor = bgColor;
        [self addSubview:_lineLable];
        
        _explainsLabel = [[UILabel alloc] init];
        _explainsLabel.font = titleFont_15;
        _explainsLabel.textColor = lgrayColor;
        _explainsLabel.numberOfLines = 0;
        [self addSubview:_explainsLabel];
        [_explainsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_lineLable.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
    
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
