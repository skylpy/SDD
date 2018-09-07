//
//  successCell.m
//  成功领取折扣券
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "successCell.h"

@implementation successCell

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
    
    UIImageView * logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(126/2, 44/2, 52/2, 52/2)];
    logoImage.image = [UIImage imageNamed:@"coupons_icon_successful_blue"];
    [self addSubview:logoImage];
    
    _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(175/2, 46/2, 360/2, 25)];
    _titLabel.text = @"恭喜您领取成功！";
    _titLabel.textAlignment = NSTextAlignmentCenter;
    _titLabel.font = [UIFont systemFontOfSize:22];
    [self addSubview:_titLabel];
    
    _ContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_titLabel.frame)+10, viewWidth-16, 15)];
    _ContentLabel.numberOfLines = 0;
    _ContentLabel.font = midFont;
    _ContentLabel.textAlignment = NSTextAlignmentCenter;
    [_ContentLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_ContentLabel];
    
    UILabel * tentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15/2, CGRectGetMaxY(_ContentLabel.frame)+5, 305, 15)];
    //tentLabel.numberOfLines = 0;
    tentLabel.font = [UIFont systemFontOfSize:13];
    tentLabel.textAlignment = NSTextAlignmentCenter;
    [tentLabel setTextColor:[UIColor grayColor]];
    tentLabel.text = @"可在我的品牌-我的折扣券中";
    [self addSubview:tentLabel];
    
    UILabel * tLabel = [[UILabel alloc] initWithFrame:CGRectMake(15/2, CGRectGetMaxY(tentLabel.frame)+5, 305, 15)];
    //tLabel.numberOfLines = 0;
    tLabel.font = [UIFont systemFontOfSize:13];
    tLabel.textAlignment = NSTextAlignmentCenter;
    [tLabel setTextColor:[UIColor grayColor]];
    tLabel.text = @"查看详细情况";
    [self addSubview:tLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
