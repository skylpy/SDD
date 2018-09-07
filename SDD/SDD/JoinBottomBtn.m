//
//  JoinBottomBtn.m
//  SDD
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinBottomBtn.h"

@implementation JoinBottomBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect = CGRectMake(self.frame.size.width/2-8, 3, 15, 15);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(0, 15, self.frame.size.width, self.frame.size.height-15);
    return titleRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
