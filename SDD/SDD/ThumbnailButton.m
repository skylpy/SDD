//
//  ThumbnailButton.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ThumbnailButton.h"

@implementation ThumbnailButton


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        // 图片
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.frame = CGRectMake(10, 10, 140, 80);
        _imgView.layer.borderColor = divisionColor.CGColor;
        _imgView.layer.borderWidth = 1;
        [self addSubview:_imgView];
        
        // 大标题
        _topLabel = [[UILabel alloc] init];
        _topLabel.frame = CGRectMake(10, CGRectGetMaxY(_imgView.frame)+10, 140, 15);
        _topLabel.font = midFont;
        _topLabel.textColor = mainTitleColor;
        [self addSubview:_topLabel];
        
        // 大标题
        _midLabel = [[UILabel alloc] init];
        _midLabel.frame = CGRectMake(10, CGRectGetMaxY(_topLabel.frame)+5, 140, 15);
        _midLabel.font = midFont;
        _midLabel.textColor = lgrayColor;
        [self addSubview:_midLabel];
        
        // 小标题
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.frame = CGRectMake(10, CGRectGetMaxY(_midLabel.frame)+5, 140, 15);
        _bottomLabel.font = midFont;
        _bottomLabel.textColor = lgrayColor;
        [self addSubview:_bottomLabel];
        
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
