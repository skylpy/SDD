//
//  JoinBottomButton.m
//  SDD
//
//  Created by hua on 15/7/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinBottomButton.h"

@implementation JoinBottomButton

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        return self;
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setImage:image forState:state];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
