//
//  HouseFind.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseFind.h"

@implementation HouseFind

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;

        _peripheralSupport = [UIButton buttonWithType:UIButtonTypeCustom];
        _peripheralSupport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _peripheralSupport.titleLabel.font = midFont;
        [_peripheralSupport setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_peripheralSupport];
        
        [_peripheralSupport mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(viewWidth-16, 40));
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
