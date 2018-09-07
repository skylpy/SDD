//
//  LabelTextfieldView.m
//  SDD
//
//  Created by hua on 15/4/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "LabelTextfieldView.h"

@implementation LabelTextfieldView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(10, 0, 60
                                       *MULTIPLE, self.frame.size.height);
        [self addSubview:_titleLabel];
        
        _textField = [[UITextField alloc]init];
        _textField.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+5, 0, self.frame.size.width-_titleLabel.frame.size.width-15, self.frame.size.height);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:_textField];
        
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
