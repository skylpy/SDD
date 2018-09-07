//
//  SDD_MyPersonList.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_MyPersonList.h"

@implementation SDD_MyPersonList

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
       _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        [self addSubview:_imageV];
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(41, 15, 200, 20)];
        [self addSubview:_nameLable];
        
        _ValidationLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 13, 40, 20)];
        _ValidationLabel.text = @"已验证";
        _ValidationLabel.textColor = [UIColor orangeColor];
        [self addSubview:_ValidationLabel];
                                
    }
    return self;
}
@end
