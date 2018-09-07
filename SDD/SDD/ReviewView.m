//
//  ReviewView.m
//  SDD
//
//  Created by hua on 15/4/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ReviewView.h"

@implementation ReviewView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 评分标题
        _starTitle = [[UILabel alloc] init];
        _starTitle.frame = CGRectMake(10, 1.5, self.frame.size.width/6, 13);
        _starTitle.textColor = deepBLack;
        _starTitle.textAlignment = NSTextAlignmentCenter;
        _starTitle.font =  [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [self addSubview:_starTitle];
        
        // 评分
        _starRate = [[CWStarRateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_starTitle.frame)+5, 0, self.frame.size.width*2/3-30, 16) numberOfStars:5];
        _starRate.hasAnimation = YES;
        [self addSubview:_starRate];
        
        // 得分
        _score = [[UILabel alloc] init];
        _score.frame = CGRectMake(CGRectGetMaxX(_starRate.frame)+5, 2, self.frame.size.width/7, 13);
        _score.text = @"0.0分";
        _score.textColor = deepBLack;
        _score.font = [UIFont systemFontOfSize:13];
        [self addSubview:_score];
    
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
