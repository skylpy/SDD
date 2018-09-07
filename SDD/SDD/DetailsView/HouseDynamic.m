//
//  HouseDynamic.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseDynamic.h"

@implementation HouseDynamic

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _dynamicTitle = [[UILabel alloc] init];
        _dynamicTitle.font = midFont;
        _dynamicTitle.textColor = lgrayColor;
        
        _dynamicTime = [[UILabel alloc] init];
        _dynamicTime.font = [UIFont systemFontOfSize:12];
        _dynamicTime.textColor = lgrayColor;
        _dynamicTime.numberOfLines = 0;
        
        [self addSubview:_dynamicTitle];
        [_dynamicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.height.equalTo(@13);
        }];
        
        [self addSubview:_dynamicTime];
        [_dynamicTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dynamicTitle.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.height.equalTo(@30);
        }];
        
        return self;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
