//
//  CustomButton.m
//  SDD
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect = CGRectMake(self.frame.size.width-15, 15, 8, 8);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(10, 0, 50, self.frame.size.height);
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
