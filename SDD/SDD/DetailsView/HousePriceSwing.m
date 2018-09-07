//
//  HousePriceSwing.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HousePriceSwing.h"

@implementation HousePriceSwing

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;

        _movements_bg = [[UIScrollView alloc] init];
        _movements_bg.frame = CGRectMake(0, 0, viewWidth, 190);
        _movements_bg.pagingEnabled = YES;
        _movements_bg.backgroundColor = [UIColor whiteColor];
        _movements_bg.contentSize = CGSizeMake(viewWidth*2, 190);
        [self addSubview:_movements_bg];
        
        _movementCity = [[UILabel alloc] init];
        _movementCity.frame = CGRectMake(0, CGRectGetMaxY(_movements_bg.frame), viewWidth, 30);
        _movementCity.font = midFont;
        _movementCity.backgroundColor = [UIColor whiteColor];
        _movementCity.textColor = [UIColor orangeColor];
        [self addSubview:_movementCity];
        
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
