//
//  SignInBtn.m
//  SDD
//
//  Created by mac on 15/12/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SignInBtn.h"

@implementation SignInBtn


-(CGRect)imageRectForContentRect:(CGRect)contentRect{

    CGRect imageRect = CGRectMake(self.frame.size.width/2-10, 5, 20, 20);
    return imageRect;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    CGRect titleRect = CGRectMake(0, 25, self.frame.size.width, 20);
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
