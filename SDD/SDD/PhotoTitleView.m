//
//  PhotoTitleView.m
//  SDD
//
//  Created by mac on 15/12/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PhotoTitleView.h"

@implementation PhotoTitleView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"描述";
        [_titleLabel setTextColor:lgrayColor];
        _titleLabel.font = titleFont_15;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        _storeDescriptionLabel = [[UILabel alloc] init];
        [_storeDescriptionLabel setTextColor:lgrayColor];
        _storeDescriptionLabel.font = midFont;
        _storeDescriptionLabel.numberOfLines = 0;
        [self addSubview:_storeDescriptionLabel];
        [_storeDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
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
