//
//  ConfirmButton.m
//  SDD
//
//  Created by hua on 15/8/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ConfirmButton.h"

@implementation ConfirmButton


- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action{
    
    self = [super initWithFrame:frame];
    
    if (!self) {
        
        return nil;
    }
    else {
        
        self.titleLabel.font = largeFont;
        [self setTitle:NSLocalizedString(title, @"") forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:dblueColor forState:UIControlStateDisabled];
        [self setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                         size:CGSizeMake(viewWidth-40, 45)]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[Tools_F imageWithColor:[UIColor whiteColor]
                                                    size:CGSizeMake(viewWidth-40, 45)]
                        forState:UIControlStateDisabled];
        [self setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                    size:CGSizeMake(viewWidth-40, 45)]
                        forState:UIControlStateHighlighted];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [Tools_F setViewlayer:self cornerRadius:5 borderWidth:1 borderColor:dblueColor];
        self.enabled = NO;   // 默认不能点击
        
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
