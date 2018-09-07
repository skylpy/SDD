//
//  SDD_MyIssueStatusCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_MyIssueStatusCell.h"
#import "SDDColor.h"
@implementation SDD_MyIssueStatusCell

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
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 100, 15)];
        _nameLable.text = @"";
        [self addSubview:_nameLable];
        
        UIButton *statusButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 14, 80, 15)];
        [statusButton setTitleColor:[SDDColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        statusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        statusButton.tag = 1000;
        [self addSubview:statusButton];
    }
    return self;
}
@end
