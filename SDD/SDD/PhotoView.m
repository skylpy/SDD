//
//  PhotoView.m
//  SDD
//
//  Created by mac on 15/12/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
    
}

-(void)createUI{

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"照片";
    [_titleLabel setTextColor:lgrayColor];
    _titleLabel.font = titleFont_15;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    _leftImage = [[UIImageView alloc] init];
    _leftImage.image = [UIImage imageNamed:@"square_loading"];
    [self addSubview:_leftImage];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth/5*3-20, 125));
    }];
    
    _rightTImage = [[UIImageView alloc] init];
    _rightTImage.image = [UIImage imageNamed:@"square_loading"];
    [self addSubview:_rightTImage];
    [_rightTImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(_leftImage.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@(125/2-5));
    }];
    
    
    _rightBImage = [[UIImageView alloc] init];
    _rightBImage.image = [UIImage imageNamed:@"square_loading"];
    [self addSubview:_rightBImage];
    [_rightBImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_rightTImage.mas_bottom).with.offset(10);
        make.left.equalTo(_leftImage.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@(125/2-5));
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
