//
//  ShopBtn.m
//  SDD
//
//  Created by mac on 15/12/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ShopBtn.h"

@implementation ShopBtn


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect = CGRectMake(10,5, 20, 20);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(40, 0, self.frame.size.width-40, 30);
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
