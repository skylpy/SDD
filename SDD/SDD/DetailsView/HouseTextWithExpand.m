//
//  HouseTextWithExpand.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseTextWithExpand.h"

@implementation HouseTextWithExpand

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        // 分割线
        UIView *cutOff = [[UIView alloc] init];
        cutOff.backgroundColor = bgColor;
        
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _expandButton.backgroundColor = [UIColor whiteColor];
        [_expandButton setImage:[UIImage imageNamed:@"向下-图标"] forState:UIControlStateNormal];
        [_expandButton setImageEdgeInsets:UIEdgeInsetsMake(6.5, viewWidth/2+6, 6.5, viewWidth/2+6)];
        
        [self addSubview:cutOff];
        [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-21);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
        }];
        
        [self addSubview:_expandButton];
        [_expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutOff.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 20));
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
