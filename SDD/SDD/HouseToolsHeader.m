//
//  HouseTools.m
//  SDD
//
//  Created by Cola on 15/4/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseToolsHeader.h"

@implementation HouseToolsHeader

- (UIButton *) houseCreditBtn
{
    if (!_houseCreditBtn) {
        _houseCreditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _houseCreditBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        [self addSubview:_houseCreditBtn];
    }
    return _houseCreditBtn;
}

- (UIButton *) taxBtn
{
    if (!_taxBtn) {
        _taxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _taxBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _taxBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_taxBtn];
    }
    return _taxBtn;
}

- (UIButton *) scanBtn
{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        [self addSubview:_scanBtn];
    }
    return _scanBtn;
}

- (UILabel *) houseTools
{
    if (!_houseTools) {
        _houseTools = [[UILabel alloc] init];
        _houseTools.numberOfLines = 1;
//        _houseTools.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:_houseTools];
    }
    return _houseTools;
}

- (UIView *) transverse
{
    if (!_transverse) {
        _transverse = [[UIView alloc] init];
        [self addSubview:_transverse];
    }
    return _transverse;
}

- (UIView *) transverse2
{
    if (!_transverse2) {
        _transverse2 = [[UIView alloc] init];
        [self addSubview:_transverse2];
    }
    return _transverse2;
}

- (UIView *) transverse3
{
    if (!_transverse3) {
        _transverse3 = [[UIView alloc] init];
        [self addSubview:_transverse3];
    }
    return _transverse3;
}

- (void)layoutSubviews {
    _houseTools.frame = CGRectMake(10, 10, _houseTools.text.length * _houseTools.font.pointSize, _houseTools.font.lineHeight);
    _transverse.frame = CGRectMake(0, CGRectGetMaxY(_houseTools.frame) + 10, viewWidth, 0.5);
    float p = self.bounds.size.height - 20 - _houseTools.font.lineHeight;
    _houseCreditBtn.frame = CGRectMake(0 , p - p/3,viewWidth/3, p);
    _taxBtn.frame = CGRectMake(viewWidth/3 , p - p/3,viewWidth/3, p);
    _scanBtn.frame = CGRectMake(viewWidth - viewWidth/3 , p - p/3,viewWidth/3, p);
    
    _transverse2.frame = CGRectMake(viewWidth/3-0.5, CGRectGetMaxY(_transverse.frame), 0.5, self.bounds.size.height - 20 - _houseTools.font.lineHeight);
    _transverse3.frame = CGRectMake(viewWidth - viewWidth/3 -0.5, CGRectGetMaxY(_transverse.frame), 0.5, self.bounds.size.height - 20 - _houseTools.font.lineHeight);
}
@end
