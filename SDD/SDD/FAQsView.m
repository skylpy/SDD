//
//  FAQsView.m
//  SDD
//
//  Created by hua on 15/7/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FAQsView.h"

@implementation FAQsView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = bgColor;
        
        // 搜索栏
        _headSearch = [[UISearchBar alloc] init];
        _headSearch.placeholder = @"请输入您的问题";
        
        [self addSubview:_headSearch];
        [_headSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 44));
        }];
        
        // 热门标签
        _hotTagScrollView = [[UIScrollView alloc] init];
        _hotTagScrollView.backgroundColor = bgColor;
        _hotTagScrollView.showsHorizontalScrollIndicator = NO;
        _hotTagScrollView.showsVerticalScrollIndicator = NO;
        _hotTagScrollView.bounces = NO;
        
        [self addSubview:_hotTagScrollView];
        [_hotTagScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headSearch.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 44));
        }];
        
        // 问答列表
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.backgroundColor = bgColor;
        [self addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_hotTagScrollView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
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
