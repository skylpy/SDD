//
//  ServiceButton.m
//  sdd_iOS_personal
//
//  Created by hua on 15/4/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ServiceButton.h"

@implementation ServiceButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // icon
        _icon = [[UIImageView alloc] init];
        _icon.frame = CGRectMake(self.frame.size.height/6, self.frame.size.height/6, self.frame.size.height*2/3, self.frame.size.height*2/3);
        [self addSubview:_icon];
        
        // 大标题
        _topLabel = [[UILabel alloc] init];
        _topLabel.frame = CGRectMake(CGRectGetMaxX(_icon.frame)+5, self.frame.size.height/6, self.frame.size.width-_icon.frame.size.width, self.frame.size.height*2/3);
        _topLabel.textColor = deepBLack;
        _topLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_topLabel];
        
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
