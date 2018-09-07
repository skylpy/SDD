//
//  JoinDynamic.m
//  SDD
//
//  Created by hua on 15/6/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinDynamic.h"

@implementation JoinDynamic
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _dynamicTitle = [[UILabel alloc] init];
        _dynamicTitle.font = largeFont;
        _dynamicTitle.textColor = [UIColor blackColor];
        
        _dynamicContent = [[UILabel alloc] init];
        _dynamicContent.font = [UIFont systemFontOfSize:11];
        _dynamicContent.textColor = lgrayColor;
        _dynamicContent.numberOfLines = 0;
        
        [self addSubview:_dynamicTitle];
        [_dynamicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.height.equalTo(@16);
        }];
        
        [self addSubview:_dynamicContent];
        [_dynamicContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dynamicTitle.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.left.equalTo(self.mas_left).with.offset(8);
        }];
        
        return self;
    }
}
@end
