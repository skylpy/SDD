//
//  HouseDetailTitle.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseDetailTitle.h"

@implementation HouseDetailTitle


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        // 标题
        _theTitle = [[UILabel alloc] init];
        _theTitle.font = [UIFont fontWithName:@"ProN-HiraKakuProN-W6" size:16*MULTIPLE];
        _theTitle.textColor = [UIColor blackColor];
        [self addSubview:_theTitle];
        [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@10);
            make.height.equalTo(@40);
        }];
        
        // 下分割线
        _cutOff = [[UIView alloc] init];
        _cutOff.backgroundColor = divisionColor;
        [self addSubview:_cutOff];
        [_cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(@10);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
        
        return self;
    }
}

- (void)setTitleType:(TitleType)titleType{
    
    // 据类型增加
    switch (titleType) {
        case haveArrow:
        {
            _arrowImgView = [[UIImageView alloc] init];
            _arrowImgView.image = [UIImage imageNamed:@"gray_rightArrow"];
            [self addSubview:_arrowImgView];
            [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(7, 12));
            }];
            
            [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_arrowImgView.mas_left).with.offset(-10);
            }];
        }
            break;
        case haveButton:
        {
            
            _segmented = [[UISegmentedControl alloc] initWithItems:@[@"一年",@"两年"]];
            _segmented.tintColor = divisionColor;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:lgrayColor, NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue-Bold"size:13],NSFontAttributeName ,nil];
            [_segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
            NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue-Bold"size:13],NSFontAttributeName ,nil];
            [_segmented setTitleTextAttributes:dic2 forState:UIControlStateSelected];
            _segmented.selectedSegmentIndex = 0;
            
            [self addSubview:_segmented];
            [_segmented mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(80, 20));
            }];
            
            [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_segmented.mas_left).with.offset(-10);
            }];
        }
            break;
        case haveArrowWithText:
        {
            UIImageView *arrowImgView = [[UIImageView alloc] init];
            arrowImgView.image = [UIImage imageNamed:@"gray_rightArrow"];
            [self addSubview:arrowImgView];
            
            UILabel *label = [[UILabel alloc] init];
            label.font = bottomFont_12;
            label.textColor = lgrayColor;
            label.text = @"更多";
            [self addSubview:label];

            [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(7, 12));
            }];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(arrowImgView.mas_left).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(25*MULTIPLE, 40));
            }];
            
            [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(arrowImgView.mas_left).with.offset(-10);
            }];
        }
            break;
        default:{
            
            [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self).with.offset(-20);
            }];
        }
            break;
    }
}


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
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
