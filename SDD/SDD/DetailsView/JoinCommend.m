//
//  JoinCommend.m
//  SDD
//
//  Created by hua on 15/6/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinCommend.h"

@implementation JoinCommend

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _theAvatar = [[UIImageView alloc] init];
        _theAvatar.clipsToBounds = YES;
        _theAvatar.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_theAvatar];
        
        _theName = [[UILabel alloc] init];
        _theName.font = [UIFont systemFontOfSize:14];
        [self addSubview:_theName];
        
        _theStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, viewWidth/3, 15) numberOfStars:5];
        _theStar.scorePercent = 0.f;
        _theStar.userInteractionEnabled = NO;           // 不评
        [self addSubview:_theStar];
        
        _theCommend = [[UILabel alloc] init];
        _theCommend.font = midFont;
        _theCommend.textColor = lgrayColor;
        _theCommend.numberOfLines = 0;
        [self addSubview:_theCommend];
        
        _theTime = [[UILabel alloc] init];
        _theTime.font = littleFont;
        _theTime.textColor = lgrayColor;
        [self addSubview:_theTime];
        
        _theAppraise = [[UILabel alloc] init];
        _theAppraise.font = midFont;
        _theAppraise.textColor = lorangeColor;
        [self addSubview:_theAppraise];
        
        _theLike = [ButtonWithNumber buttonWithType:UIButtonTypeCustom];
        _theLike.titleLabel.font = littleFont;
        [_theLike setTitle:@"0" forState:UIControlStateNormal];
        [_theLike setTitleColor:lgrayColor forState:UIControlStateNormal];
        [_theLike setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_theLike setImage:[UIImage imageNamed:@"join_remark-on_icon_Some-praise"] forState:UIControlStateNormal];
        [_theLike setImage:[UIImage imageNamed:@"join_detail-pages_icon_Some-praise"] forState:UIControlStateSelected];
        [self addSubview:_theLike];
        
        [_theAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_theName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(_theAvatar.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(@14);
        }];
        
        [_theStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_theAvatar.mas_bottom);
            make.left.equalTo(_theAvatar.mas_right).with.offset(10);
            make.width.mas_equalTo(viewWidth/3);
            make.height.equalTo(@15);
        }];
        
        [_theAppraise mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(35);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.height.equalTo(@13);
        }];
        
        [_theCommend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theAvatar.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.height.lessThanOrEqualTo(@35);
        }];
        
        [_theTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theCommend.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.right.equalTo(_theLike.mas_left).with.offset(-8);
            make.height.lessThanOrEqualTo(@13);
        }];
        
        [_theLike mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theCommend.mas_bottom).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.width.equalTo(@60);
            make.height.lessThanOrEqualTo(@13);
        }];
        
        return self;
    }
}

@end
