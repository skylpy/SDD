//
//  RegionSelectButton.m
//  SDD
//
//  Created by hua on 15/8/7.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "RegionSelectButton.h"

@implementation RegionSelectButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect = CGRectMake(self.frame.size.width-self.frame.size.height-2, 3, self.frame.size.height-5, self.frame.size.height-5);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(0, 0, self.frame.size.width-self.frame.size.height-5, self.frame.size.height);
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
