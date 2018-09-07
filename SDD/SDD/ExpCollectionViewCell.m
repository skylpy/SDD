//
//  ExpCollectionViewCell.m
//  SDD
//
//  Created by mac on 15/12/8.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ExpCollectionViewCell.h"

@implementation ExpCollectionViewCell

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _headerImage = [[UIImageView alloc] init];
    _headerImage.image = [UIImage imageNamed:@"cell_loading"];
    [self addSubview:_headerImage];
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(viewWidth/2-60));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = midFont;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_headerImage.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _IntegralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _IntegralBtn.backgroundColor = tagsColor;
    _IntegralBtn.layer.cornerRadius = 5;
    _IntegralBtn.clipsToBounds = YES;
    _IntegralBtn.titleLabel.font = midFont;
    [self addSubview:_IntegralBtn];
    [_IntegralBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = midFont;
    _numLabel.textColor = tagsColor;
    [self addSubview:_numLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"icon-points-y"];
    [self addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.right.equalTo(_numLabel.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

@end
