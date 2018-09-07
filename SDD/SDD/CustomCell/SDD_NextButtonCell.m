//
//  SDD_NextButtonCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_NextButtonCell.h"
#import "SDDColor.h"
@implementation SDD_NextButtonCell

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
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 0, viewWidth-20, 40);
        [button setBackgroundImage:[UIImage imageNamed:@"the_next_step_btn_did_not_click"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.tag = 10;
        [self addSubview:button];
        
        UIButton * sctButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sctButton.frame =CGRectMake(20, 56, 15, 15);
        sctButton.tag = 30;
        [self addSubview:sctButton];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 100, 10)];
        lable.text = @"我已阅读并同意";
        lable.textColor = lgrayColor;
        lable.font = bottomFont_12;
        lable.tag = 15;
        [self addSubview:lable];
        
        UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        positionBtn.frame =CGRectMake(135, 55, 115, 15);
        [positionBtn setTitle:@"商多多发布协议" forState:UIControlStateNormal];
        [positionBtn setTitleColor:tagsColor forState:UIControlStateNormal] ;
        positionBtn.titleLabel.font = bottomFont_12;
        positionBtn.tag = 150;
        positionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
        //positionBtn.backgroundColor = [UIColor redColor];
        [self addSubview:positionBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(135, 70, 95, 1)];
        line.backgroundColor = tagsColor;
        line.tag = 12;
        [self addSubview:line];
        
        UIButton *positionButton  =[[UIButton alloc] initWithFrame:CGRectMake(125, 60, 95, 10)];
        positionButton.tag = 20;
        [self addSubview:positionButton];
    }
    return self;
}

@end
