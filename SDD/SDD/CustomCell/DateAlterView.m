//
//  DateAlterView.m
//  SDD
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DateAlterView.h"

@implementation DateAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(20, 100, 280, 160);
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self addSubview:_nameLabel];
        NSDate *date1 = [NSDate date];
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat dateFromString:@"yyyy   MM   dd"];
        NSString * dateToString = [dateFormat stringFromDate:date1];
        for (int i=0; i<3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+i*20, 280, 20)];
            label.text = dateToString;
            [self addSubview:label];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 120, 120, 20)];
        [button setBackgroundImage:[UIImage imageNamed:@"determine_the_click_btn"] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:button];
        
    }
    return self;
}
@end
