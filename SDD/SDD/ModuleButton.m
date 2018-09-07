//
//  moduleButton.m
//  sdd_iOS_personal
//
//  Created by hua on 15/4/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ModuleButton.h"

@implementation ModuleButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // icon
        _icon = [[UIImageView alloc] init];
        _icon.frame = CGRectMake(0, 0, self.frame.size.height*3/5-5, self.frame.size.height*3/5-5);
        _icon.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/3+4);
        [self addSubview:_icon];
        
        // 小标题
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.frame = CGRectMake(0, CGRectGetMaxY(_icon.frame)+10, self.frame.size.width, 13);
        _bottomLabel.textColor = lgrayColor;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = bottomFont_12;
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
