//
//  TabButton.m
//  SDD
//
//  Created by hua on 15/7/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "TabButton.h"

@implementation TabButton

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        return self;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect imageRect;
    if (_isLittle) {
        
        imageRect = CGRectMake((self.frame.size.width-self.frame.size.height*1/2)/2, 5, self.frame.size.height*1/2, self.frame.size.height*1/2);
    }
    else {
        
        imageRect = CGRectMake((self.frame.size.width-self.frame.size.height*2/3)/2, 0, self.frame.size.height*2/3, self.frame.size.height*2/3);
    }
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGRect titleRect = CGRectMake(0, self.frame.size.height-15, self.frame.size.width, 15);
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
