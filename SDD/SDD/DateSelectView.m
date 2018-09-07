//
//  DateSelectView.m
//  SDD
//
//  Created by hua on 15/7/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DateSelectView.h"

@implementation DateSelectView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        UIView *white_bg = [[UIView alloc] init];
        white_bg.backgroundColor = [UIColor whiteColor];
        [self addSubview:white_bg];
        [white_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.edges.equalTo(self);
        }];
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 标题
        _theTitle = [[UILabel alloc] init];
        _theTitle.font = largeFont;
        _theTitle.textAlignment = NSTextAlignmentCenter;
        
        [white_bg addSubview:_theTitle];
        [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
        }];
        
        // 分割线
        UIView *cutoff = [[UIView alloc] init];
        cutoff.backgroundColor = divisionColor;
        
        [white_bg addSubview:cutoff];
        [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theTitle.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 1));
        }];
        
        // 时间选择
        _theDatePicker = [[UIDatePicker alloc] init];
        _theDatePicker.frame = CGRectMake(0, 36, viewWidth-40, 140);    // 使用masonry无法设置大小
        _theDatePicker.datePickerMode = UIDatePickerModeDate;
        
        [white_bg addSubview:_theDatePicker];
//        [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cutoff.mas_bottom);
//            make.centerX.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 140));
//        }];
        
        // 确定
//        _confirmButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//        _confirmButton.backgroundColor = deepOrangeColor;
//        [Tools_F setViewlayer:_confirmButton cornerRadius:5 borderWidth:0 borderColor:nil];        
//        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
//        
//        [self addSubview:_confirmButton];
//        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-15);
//            make.centerX.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(100, 65/2));
//        }];
        
        _confirmButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 5, viewWidth - 40, 45)
                                                        title:@"确定"
                                                       target:nil
                                                       action:nil];
        _confirmButton.enabled = YES;
        [white_bg addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 65/2));
        }];
        
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
