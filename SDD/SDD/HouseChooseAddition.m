//
//  HouseChooseAddition.m
//  SDD
//
//  Created by hua on 15/6/4.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseChooseAddition.h"

@implementation HouseChooseAddition

//- (UILabel *)title_a{
//    
//    if (_title_a) {
//        
//        _title_a = [[UILabel alloc] init];
//        _title_a.frame = CGRectMake(15, 0, 50, 30);
//        _title_a.font= midFont;
//        [self addSubview:_title_a];
//    }
//    return _title_a;
//}
//
//- (UILabel *)title_b{
//    
//    if (_title_b) {
//        
//        _title_b = [[UILabel alloc] init];
//        _title_b.frame = CGRectMake(15, CGRectGetMaxY(_title_a.frame), 50, 30);
//        _title_b.font= midFont;
//        [self addSubview:_title_b];
//    }
//    return _title_b;
//}
//
//- (UIImageView *)imgBg{
//    
//    if (_imgBg) {
//        
//        _imgBg = [[UIImageView alloc] init];
//        _imgBg.frame = CGRectMake(70, 5, viewWidth-70, 50);
//        [self addSubview:_imgBg];
//        
//        for (int i=0; i<6; i++) {
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame =  CGRectMake((viewWidth-70)/3*(i%3), 30*(i/3), (viewWidth-70)/3, 30);
//            btn.tag = 100+i;
//            btn.backgroundColor = RandomColor;
//            [_imgBg addSubview:btn];
//        }
//    }
//    return _imgBg;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _title_a = [[UILabel alloc] init];
        _title_a.frame = CGRectMake(15, 0, 50, 30);
        _title_a.font= midFont;
        [self addSubview:_title_a];
        
        _title_b = [[UILabel alloc] init];
        _title_b.frame = CGRectMake(15, CGRectGetMaxY(_title_a.frame), 50, 30);
        _title_b.font= midFont;
        [self addSubview:_title_b];
        
        _imgBg = [[UIImageView alloc] init];
        _imgBg.frame = CGRectMake(70, 5, viewWidth-70, 50);
        _imgBg.userInteractionEnabled = YES;
        [self addSubview:_imgBg];
        
        for (int i=0; i<6; i++) {
            
            UITextField *textField = [[UITextField alloc] init];
            textField.frame =  CGRectMake((viewWidth-70)/3*(i%3)+20, -5+30*(i/3), (viewWidth-70)/3-40, 30);
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = midFont;
            textField.tag = 100+i;
            [_imgBg addSubview:textField];
            
            if (i>2) {
                
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(CGRectGetMaxX(textField.frame), textField.frame.origin.y, 20, 30);
                label.text = @"m²";
                label.font = midFont;
                [_imgBg addSubview:label];
            }
        }
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
