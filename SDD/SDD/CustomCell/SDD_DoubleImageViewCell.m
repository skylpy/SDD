//
//  SDD_DoubleImageViewCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_DoubleImageViewCell.h"

@implementation SDD_DoubleImageViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i=0; i<2; i++) {
            NSArray *imageArr = [NSArray arrayWithObjects:@"upload-the-whole-rendering_icon",@"upload-business-license_icon",@"上传整体效果图",@"上传营销中心图", nil];
            UIImageView *xiaoGuoImage = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/6.5)+i*(viewWidth/2), 25, 70, 70)];
            xiaoGuoImage.image = [UIImage imageNamed:imageArr[i]];
            xiaoGuoImage.tag = 111+i;
            [self addSubview:xiaoGuoImage];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth/6.5-10)+i*(viewWidth/2), 110, 90, 10)];
            label.text = imageArr[i+2];
            label.tag = 333+i;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            //label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
            
            UIButton *button  =[[UIButton alloc] initWithFrame:CGRectMake((viewWidth/6.5)+i*(viewWidth/2), 25, 70, 70)];
            [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            button.tag = 222+i;
            [self addSubview:button];
        }
    }
    return self;
}

@end
