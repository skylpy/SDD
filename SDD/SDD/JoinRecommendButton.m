//
//  JoinRecommendButton.m
//  SDD
//
//  Created by hua on 15/6/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinRecommendButton.h"

@implementation JoinRecommendButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;

//        _imgView.frame = CGRectMake(10, 10, 125, 70);
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
        
        // 品牌名
        _brankName = [[UILabel alloc] init];
//        _brankName.frame = CGRectMake(10, CGRectGetMaxY(_imgView.frame)+10, 125, 13);
        _brankName.textColor = lgrayColor;
        _brankName.font = midFont;
        [self addSubview:_brankName];
        
        // 投资总额度
        _investmentAmountCategoryName = [[UILabel alloc] init];
//        _investmentAmountCategoryName.frame = CGRectMake(10, CGRectGetMaxY(_brankName.frame)+7, 125, 13);
        _investmentAmountCategoryName.textColor = lgrayColor;
        _investmentAmountCategoryName.font = midFont;
        [self addSubview:_investmentAmountCategoryName];
        
        // 行业类别
        _industryCategoryName = [[UILabel alloc] init];
//        _industryCategoryName.frame = CGRectMake(10, CGRectGetMaxY(_investmentAmountCategoryName.frame)+7, 125, 13);
        _industryCategoryName.textColor = lgrayColor;
        _industryCategoryName.font = midFont;
        [self addSubview:_industryCategoryName];
        
        // 门店数量
        _storeAmount = [[UILabel alloc] init];
//        _storeAmount.frame = CGRectMake(10, CGRectGetMaxY(_industryCategoryName.frame)+7, 125, 13);
        _storeAmount.textColor = lgrayColor;
        _storeAmount.font = midFont;
        [self addSubview:_storeAmount];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(125, 70));
        }];
        
        [_brankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(125, 13));
        }];
        
        [_investmentAmountCategoryName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_brankName.mas_bottom).with.offset(7);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(125, 13));
        }];
        
        [_industryCategoryName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_investmentAmountCategoryName.mas_bottom).with.offset(7);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(125, 13));
        }];
        
        [_storeAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_industryCategoryName.mas_bottom).with.offset(7);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(125, 13));
        }];        
    }
    return self;
}


@end
