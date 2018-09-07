//
//  AnswerLabel.m
//  SDD
//
//  Created by mac on 15/8/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "AnswerLabel.h"

@implementation AnswerLabel

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        
//        self.backgroundColor = bgColor;
//        _label = [[UILabel alloc] init];
//        [_label setTextColor:lgrayColor];
//        _label.font = titleFont_14;
//        [self addSubview:_label];
//        
//        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).with.offset(5);
//            make.left.equalTo(self.mas_left).with.offset(8);
//            make.right.equalTo(self.mas_right).with.offset(-8);
//            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
//        }];
//        _label = self;
//        
//        
//        
//    }
//    return self;
//}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        //[self setLineBreakMode:UILineBreakModeWordWrap|UILineBreakModeTailTruncation];
        self.font = [UIFont systemFontOfSize:14];
        [self setBackgroundColor:[UIColor clearColor]];
        //[self setTextColor:lgrayColor];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
        
        //self.frame = CGRectMake(10, 5, viewWidth-40, 40);
        
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@5);
//            make.left.equalTo(@8);
//            make.right.equalTo(@-8);
//            make.bottom.equalTo(@-5);
//        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
