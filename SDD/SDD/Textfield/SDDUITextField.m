//
//  SDDUITextField.m
//  SDD
//
//  Created by hua on 15/8/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SDDUITextField.h"

@implementation SDDUITextField

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder{
    
    self = [super initWithFrame:frame];
    
    if (!self) {
        
        return nil;
    }
    else {
        
        UIView *blockView = [[UIView alloc] init];
        blockView.frame = CGRectMake(0, 0, 10, 40);
        blockView.backgroundColor = [UIColor whiteColor];
        
        [Tools_F setViewlayer:self cornerRadius:5 borderWidth:0 borderColor:nil];
        self.font = titleFont_15;//设置字体名字和字体大小
        self.placeholder = placeholder; //默认显示的字
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        self.leftView = blockView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        return self;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
