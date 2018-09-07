//
//  HouseFloorPlans.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseFloorPlans.h"

@implementation HouseFloorPlans

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;

        _aldScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 190)];
        _aldScrollView.showsHorizontalScrollIndicator = NO;
        _aldScrollView.showsVerticalScrollIndicator = NO;
        _aldScrollView.bounces = NO;
        _aldScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_aldScrollView];
        
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
