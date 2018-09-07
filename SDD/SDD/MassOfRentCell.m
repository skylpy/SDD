//
//  MassOfRentCell.m
//  SDD
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MassOfRentCell.h"

@implementation MassOfRentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *title = [NSArray arrayWithObjects:@"1.验证手机号",@"2.填写资料",@"3.填写需求", nil];
        for (int i=0; i<3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10+i*(viewWidth/3), 16, 80, 13)];
            button.tag = 40+i;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[SDDColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [button setTitle:title[i]  forState:UIControlStateNormal];
            [self addSubview:button];
        }
        for (int i=0; i<2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110+i*(viewWidth/3), 18, 5, 10)];
            imageView.image = [UIImage imageNamed:@"the_next_icon"];
            [self addSubview:imageView];
        }
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
