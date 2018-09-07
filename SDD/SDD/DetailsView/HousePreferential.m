//
//  HousePreferential.m
//  SDD
//
//  Created by hua on 15/6/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HousePreferential.h"

@implementation HousePreferential


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        // 获取优惠
        _getDiscount = [UIButton buttonWithType:UIButtonTypeCustom];
        _getDiscount.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_getDiscount];
        [_getDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 75));
        }];
        
        // 优惠logo        
        _appVIP = [[UILabel alloc] init];
        _appVIP.backgroundColor = dblueColor;
        _appVIP.textAlignment = NSTextAlignmentCenter;
        _appVIP.font = largeFont;
        _appVIP.textColor = [UIColor whiteColor];
        _appVIP.text = @"额外\n优惠";
        _appVIP.numberOfLines = 2;
        [Tools_F setViewlayer:_appVIP cornerRadius:5 borderWidth:0 borderColor:nil];
        
        [self addSubview:_appVIP];
        [_appVIP mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_getDiscount.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        // 优惠标题(内容)
        _appDiscount = [[UILabel alloc] init];
        _appDiscount.textColor = dblueColor;
        _appDiscount.font = largeFont;
        
        [self addSubview:_appDiscount];
        [_appDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15);
            make.left.equalTo(_appVIP.mas_right).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-35);
            make.height.equalTo(@16);
        }];
        
        // 截止时间
        _remainTime = [[UILabel alloc] init];
        _remainTime.textColor = lgrayColor;
        _remainTime.font = midFont;
        
        [self addSubview:_remainTime];
        [_remainTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_getDiscount.mas_bottom).offset(-15);
            make.left.equalTo(_appVIP.mas_right).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-35);
            make.height.equalTo(@13);
        }];
        
        // 箭头
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"gray_rightArrow"];
        [self addSubview:_arrowImgView];
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_getDiscount.mas_centerY);
            make.right.equalTo(self).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(7, 12));
        }];
        
        // 分割线-横
        UIView *cutOff = [[UIView alloc] init];
        cutOff.backgroundColor = divisionColor;
        
        [self addSubview:cutOff];
        [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_getDiscount.mas_bottom);
            make.left.equalTo(@10);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
        
        // 剩余面积
        _remainArea = [[UILabel alloc] init];
        _remainArea.textColor = lgrayColor;
        _remainArea.font = midFont;
        
        [self addSubview:_remainArea];
        [_remainArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutOff.mas_bottom);
            make.left.equalTo(self.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth/2-20, 30));
        }];
        
        // 分割线-纵
        UIView *cutOff2 = [[UIView alloc] init];
        cutOff2.backgroundColor = divisionColor;
        
        [self addSubview:cutOff2];
        [cutOff2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_remainArea.mas_centerY);
            make.left.equalTo(_remainArea.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 20));
        }];
        
        // 已登记人数
        _joined = [[UILabel alloc] init];
        _joined.textColor = lgrayColor;
        _joined.font = midFont;
        
        [self addSubview:_joined];
        [_joined mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutOff.mas_bottom);
            make.left.equalTo(cutOff2.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth/2-20, 30));
        }];
    }
    return self;
}

@end
