//
//  ActiveProcessView.m
//  SDD
//
//  Created by mac on 16/1/6.
//  Copyright (c) 2016年 jofly. All rights reserved.
//

#import "ActiveProcessView.h"

@implementation ActiveProcessView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createView];
    }
    return self;
}

-(void)createView{

    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"活动流程";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UILabel * linelabel = [[UILabel alloc] init];
    linelabel.backgroundColor = bgColor;
    [self addSubview:linelabel];
    [linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    _webView = [[UIWebView alloc] init];
    //_webView.scrollView.scrollEnabled = NO;
    _webView.scalesPageToFit = NO;
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
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
