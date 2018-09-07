//
//  CouponNumberCell.m
//  成功领取折扣券
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "CouponNumberCell.h"

@implementation CouponNumberCell

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
    self.contentView.frame = CGRectMake(0, 0, viewWidth, 150);
    
    _CouponNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30/2, viewWidth, 25)];
    
    _CouponNumberLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_CouponNumberLabel];
    
    _EffectiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 128/2, viewWidth, 15)];
    _EffectiveLabel.font = [UIFont systemFontOfSize:15];
    //[_EffectiveLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_EffectiveLabel];
    
    UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, viewWidth-20, 1)];
    lineImageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:lineImageView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
