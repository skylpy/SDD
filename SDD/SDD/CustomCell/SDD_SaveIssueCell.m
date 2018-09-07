//
//  SDD_SaveIssueCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_SaveIssueCell.h"
#import "SDDColor.h"
@implementation SDD_SaveIssueCell

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
            UIButton *button = [[UIButton alloc] init];

            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button.tag = 333+i;
            [button setTitle:(i==0)?@"保存":@"发布" forState:UIControlStateNormal];
            [button setTitleColor:(i==0)?dblueColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:(i==0)?[UIColor whiteColor]:dblueColor];
            button.layer.borderWidth = 0.5f; //边框宽度
            button.layer.borderColor = [dblueColor CGColor]; //边框颜色
            
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:button];
            
            if (i == 0) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(0);
                    make.left.equalTo(self.mas_left).with.offset(20);
                    make.width.equalTo(@130);
                    make.height.equalTo(@34);
                }];
            }
            else
            {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(0);
                    make.right.equalTo(self.mas_right).with.offset(-20);
                    make.width.equalTo(@130);
                    make.height.equalTo(@34);
                }];
            }
        }
    }
    return self;
}

@end
