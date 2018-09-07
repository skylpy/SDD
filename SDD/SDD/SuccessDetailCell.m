//
//  SuccessDetailCell.m
//  成功领取折扣券
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "SuccessDetailCell.h"

@implementation SuccessDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.contentView.frame = CGRectMake(0, 0, viewWidth, 150);
    
    _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30/2, viewWidth, 25)];
    _titLabel.textAlignment = NSTextAlignmentCenter;
    _titLabel.font = largeFont;
    [self addSubview:_titLabel];
    
    _ContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15/2, 128/2, viewWidth-15, 15)];
    _ContentLabel.font = midFont;
    [_ContentLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_ContentLabel];
    
    UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, 1)];
    lineImageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:lineImageView];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
