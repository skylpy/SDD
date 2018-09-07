//
//  SDD_BasicCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_BasicCell.h"
#import "SDDColor.h"
@implementation SDD_BasicCell

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
        NSArray *title = [NSArray arrayWithObjects:@"1.基本信息",@"2.项目详情",@"3.上传资料", nil];
        for (int i=0; i<3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10+i*(viewWidth/3), 16, 60, 13)];
            button.tag = 40+i;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[SDDColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [button setTitle:title[i]  forState:UIControlStateNormal];
            [self addSubview:button];
        }
        for (int i=0; i<2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90+i*(viewWidth/3), 18, 5, 10)];
            imageView.image = [UIImage imageNamed:@"the_next_icon"];
            [self addSubview:imageView];
        }
    }
    return self;
}
@end
