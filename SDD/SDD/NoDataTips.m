//
//  NoDataTips.m
//  SDD
//
//  Created by hua on 15/8/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NoDataTips.h"

@implementation NoDataTips


- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = bgColor;
        
        return self;
    }
}

- (void)setText:(NSString *)text{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_nodataface"];
    
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(135, 135));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = titleFont_15;
    label.textColor = lgrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.numberOfLines = 0;
    
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.height.greaterThanOrEqualTo(@14);
        make.width.mas_equalTo(viewWidth-20);
    }];
}

- (void)setText:(NSString *)text
    buttonTitle:(NSString *)title
      buttonTag:(NSInteger)theTag
         target:(id)target
         action:(SEL)action{

    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_nodataface"];
    
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(135, 135));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = titleFont_15;
    label.textColor = lgrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.numberOfLines = 0;
    
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.height.greaterThanOrEqualTo(@14);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    if (title) {
        
        ConfirmButton *button = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:title
                                                              target:target
                                                              action:action];
        button.tag = theTag;
        button.enabled = YES;
        
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(15);
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
        }];
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
