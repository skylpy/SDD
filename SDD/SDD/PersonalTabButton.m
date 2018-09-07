//
//  PersonalTabButton.m
//  SDD
//
//  Created by hua on 15/7/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PersonalTabButton.h"

@implementation PersonalTabButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect = CGRectMake((self.frame.size.width-38*MULTIPLE)/2, 28*MULTIPLE, 38*MULTIPLE, 38*MULTIPLE);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(0, self.frame.size.height-32*MULTIPLE, self.frame.size.width, 15);
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
