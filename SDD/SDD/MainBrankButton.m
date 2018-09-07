//
//  MainBrankButton.m
//  SDD
//
//  Created by hua on 15/8/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MainBrankButton.h"

@implementation MainBrankButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height*2/3-10);
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(0, self.frame.size.height*2/3, self.frame.size.width, self.frame.size.height/3);
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
