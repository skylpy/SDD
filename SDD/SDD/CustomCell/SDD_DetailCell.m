//
//  SDD_DetailCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_DetailCell.h"
#import "SDDColor.h"
@implementation SDD_DetailCell

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
        UILabel *starLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 15, 15)];
        starLable.text = @"*";
        starLable.textColor = [UIColor redColor];
        starLable.textAlignment = NSTextAlignmentRight;
        starLable.tag = 40;
        [self addSubview:starLable];
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 80, 13)];
        self.nameLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nameLable];
        
        self.chooseLable = [[UILabel alloc] init];
        self.chooseLable.font = [UIFont systemFontOfSize:12];
        self.chooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
        [self addSubview:self.chooseLable];
        
        [self.chooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.right.equalTo(self.mas_right).with.offset(-30);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
    }
    return self;
}
@end
