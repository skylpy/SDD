//
//  CounselorInfoView.m
//  SDD
//
//  Created by hua on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CounselorInfoView.h"

@implementation CounselorInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 评分标题
        _gradeTitle = [[UILabel alloc] init];
        _gradeTitle.frame = CGRectMake(0, 0, self.frame.size.width/5, self.frame.size.height);
        _gradeTitle.textColor = lgrayColor;
        _gradeTitle.font = littleFont;
        _gradeTitle.textAlignment = NSTextAlignmentRight;
        [self addSubview:_gradeTitle];
        
        // 百分比
        _gradePercent = [[UILabel alloc] init];
        _gradePercent.frame = CGRectMake(self.frame.size.width/5, 0, self.frame.size.width/5, self.frame.size.height);
        _gradePercent.textColor = [UIColor blackColor];
        _gradePercent.font = littleFont;
        [self addSubview:_gradePercent];
        
        // 评分条
        // solid style, default color, not animated, no text, less border radius
        _gradeProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gradePercent.frame), self.frame.size.height/5, self.frame.size.width*2/5, self.frame.size.height*3/5)];
        _gradeProgress.color = deepOrangeColor;
        _gradeProgress.showBackgroundInnerShadow = @NO;         // 关闭阴影
        _gradeProgress.showText = @NO;
        _gradeProgress.borderRadius = @(self.frame.size.height/5);
        _gradeProgress.animate = @NO;
        _gradeProgress.type = LDProgressSolid;
        [self addSubview:_gradeProgress];
        
        // 评分条数
        _gradeCounts = [[UILabel alloc] init];
        _gradeCounts.frame = CGRectMake(CGRectGetMaxX(_gradeProgress.frame), 0, self.frame.size.width/5-10, self.frame.size.height);
        _gradeCounts.textColor = [UIColor blackColor];
        _gradeCounts.font = littleFont;
        _gradeCounts.textAlignment = NSTextAlignmentRight;
        [self addSubview:_gradeCounts];
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
