//
//  SDD_MyPersonThirdButtonCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_MyPersonThirdButtonCell.h"
#import "SDDColor.h"
@implementation SDD_MyPersonThirdButtonCell

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
        NSArray *bgButtonArr = [NSArray arrayWithObjects:@"the-message_icon",@"to-make-an-appointment_icon",@"evaluation_icon", @"消息",@"预约",@"评价",nil];
        for (int i=0; i<3; i++) {
            UIButton *button  =[[UIButton alloc] initWithFrame:CGRectMake(40+i*105, 14, 25, 25)];
            [button setBackgroundImage:[UIImage imageNamed:bgButtonArr[i]] forState:UIControlStateNormal];
            button.tag = 100+i;
            [self addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40+i*105, 43, 60, 20)];
            label.text = bgButtonArr[i+3];
            label.textColor = [SDDColor colorWithHexString:@"#999999"];
            label.font = [UIFont systemFontOfSize:12];
            [self addSubview:label];
        }
        for (int i=0; i<2; i++) {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(100+i*105, 26, 1, 20)];
            line.image = [UIImage imageNamed:@"line8"];
            [self addSubview:line];
        }

    }
    return self;
}
@end
