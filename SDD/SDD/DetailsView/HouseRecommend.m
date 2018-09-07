//
//  HouseRecommend.m
//  SDD
//
//  Created by hua on 15/6/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseRecommend.h"

@implementation HouseRecommend

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;

        _houseRecommendScrollView = [[UIScrollView alloc] init];
        _houseRecommendScrollView.backgroundColor = [UIColor whiteColor];
        _houseRecommendScrollView.showsHorizontalScrollIndicator = NO;
        _houseRecommendScrollView.showsVerticalScrollIndicator = NO;
        _houseRecommendScrollView.bounces = NO;
        [self addSubview:_houseRecommendScrollView];
        
        return self;
    }
}

@end
