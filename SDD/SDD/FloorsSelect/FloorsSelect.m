//
//  FloorsSelect.m
//  SDD
//
//  Created by hua on 15/8/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FloorsSelect.h"

@implementation FloorsSelect{
    
    NSInteger floorsCounts;
}

- (void)setWithFloorsName:(NSArray *)floorsName{
    
    floorsCounts = floorsName.count;
    self.backgroundColor = [UIColor whiteColor];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.mas_equalTo(floorsCounts<5? 30+floorsCounts*40+30:30+200+30);
    }];
    
    self.userInteractionEnabled = YES;
    
    // 上下按钮
    _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topButton setImage:[UIImage imageNamed:@"gray_up"] forState:UIControlStateNormal];
    
    [self addSubview:_topButton];
    [_topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomButton setImage:[UIImage imageNamed:@"gray_down"] forState:UIControlStateNormal];

    [self addSubview:_bottomButton];
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    // 底部滚动
    UIScrollView *bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = bgColor;
//    bg_scrollView.bounces = NO;

    [self addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topButton.mas_bottom); //with is an optional semantic filler
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(_bottomButton.mas_top);
        make.right.equalTo(self.mas_right);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = bgColor;
    
    [bg_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    UIImage *white_bg = [Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    UIImage *blur_bg = [Tools_F imageWithColor:dblueColor size:CGSizeMake(1, 1)];
    
    UIButton *lastButton;
    for (NSInteger i=0; i<floorsCounts; i++) {
        
        UIButton *floorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floorButton.tag = 100+i;
        [floorButton setTitle:floorsName[i] forState:UIControlStateNormal];
        [floorButton setTitleColor:lgrayColor forState:UIControlStateNormal];
        [floorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [floorButton setBackgroundImage:white_bg forState:UIControlStateNormal];
        [floorButton setBackgroundImage:blur_bg forState:UIControlStateSelected];
        [floorButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!lastButton) {
            floorButton.selected = YES;
        }
        
        [bg_scrollView addSubview:floorButton];
        [floorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastButton?lastButton.mas_bottom:bg_scrollView.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        lastButton = floorButton;
    }
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastButton.mas_bottom);
    }];
    
}

- (void)click:(UIButton *)btn{
    
    for (NSInteger i=100; i<100+floorsCounts; i++) {
        UIButton *all = (UIButton *)[btn.superview viewWithTag:i];
        all.selected = NO;
    }
    btn.selected = YES;
    
    NSInteger theIndex = btn.tag-100;
    [_delegate didSelectFloor:theIndex];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
