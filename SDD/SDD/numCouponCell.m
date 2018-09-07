//
//  numCouponCell.m
//  SDD
//
//  Created by mac on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "numCouponCell.h"

@implementation numCouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.contentView.frame = CGRectMake(0, 0, viewWidth, 72);
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"1234567890";
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:23];
    [self addSubview:_numLabel];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@20);
        //make.width.equalTo(@20);
    }];
    
    _EffectiveLabel = [[UILabel alloc] init];
    _EffectiveLabel.textAlignment = NSTextAlignmentCenter;
    _EffectiveLabel.text = @"使用后折扣卷失效";
    _EffectiveLabel.font = [UIFont systemFontOfSize:12];
    [_EffectiveLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_EffectiveLabel];
    
    [_EffectiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@20);
        //make.width.equalTo(@20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
