//
//  SDD_CertifyCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_CertifyCell.h"
#import "SDDColor.h"
@implementation SDD_CertifyCell

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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -10, viewWidth-20, 90)];
        label.text = @"隐私声明:\n商多多非常重视对您的个人隐私保护,严格保护您的个人信息的安全.我们使用各种安全技术和程序来保护您的个人信息不被未经授权的访问,使用或泄露。";
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [SDDColor colorWithHexString:@"#999999"];
        [self addSubview:label];
        
//        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(10, 70, viewWidth-20, 40)];
//        button.layer.borderColor = [[SDDColor colorWithHexString:@"#e73820"] CGColor];
//        button.layer.borderWidth = 0.5;
//        button.layer.cornerRadius = 5;
//        [button setTitle:@"提交" forState:UIControlStateNormal];
//        [button setTitleColor:[SDDColor colorWithHexString:@"e73820"] forState:UIControlStateNormal];
//        button.tag = 1111;
//        [self addSubview:button];
    }
    return self;
}
@end
