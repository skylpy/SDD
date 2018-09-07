//
//  SDD_MyIssueCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_MyIssueCell.h"
#import "SDDColor.h"
@implementation SDD_MyIssueCell

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
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 100, 15)];
        _nameLable.font = [UIFont systemFontOfSize:13];
        _nameLable.textColor = [UIColor blackColor];
        [self addSubview:_nameLable];
        
        UIButton *statusButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 17, 80, 15)];
        [statusButton setTitleColor:[SDDColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        statusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        statusButton.tag = 1000;
        [self addSubview:statusButton];
        
        _cityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 133)];
        _cityImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_cityImage];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, self.frame.size.width, 43)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.2;
        [self addSubview:bgView];
        
        _contextLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, 245, 13)];
        _contextLable.font = [UIFont systemFontOfSize:13];
        _contextLable.textColor = [UIColor whiteColor];
        [self addSubview:_contextLable];
        
        UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 13/2+130, 55, 30)];
        telButton.tag = 1001;
        [telButton setBackgroundImage:[UIImage imageNamed:@"make-a-phone-call_btn"] forState:UIControlStateNormal];
        [self addSubview:telButton];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 16, 10, 15)];
        imageView.image = [UIImage imageNamed:@"the_next_icon2"];
        [self addSubview:imageView];
        
    }
    return self;
}
@end
