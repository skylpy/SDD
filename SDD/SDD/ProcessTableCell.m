//
//  ProcessTableCell.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProcessTableCell.h"

@implementation ProcessTableCell

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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"发布流程";
    _titleLabel.font = midFont;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = bgColor;
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    NSArray * array = @[@"提交信息",@"认证审核",@"预约看铺",@"客户签约"];
    for (int i = 0; i < 4; i++) {
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/4)*i+(viewWidth/4/2-20),50 , 40, 40)];
        //_iconImage.backgroundColor = [UIColor orangeColor];
        _iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d",i]];
        _iconImage.layer.cornerRadius = 20;
        _iconImage.clipsToBounds = YES;
        [self addSubview:_iconImage];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/4*i-10, 65, 6, 10)];
        //_icon.backgroundColor = [UIColor blackColor];
        _icon.image = [UIImage imageNamed:@"the_next_icon"];
        [self addSubview:_icon];
        
        _proLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/4*i, 93, viewWidth/4, 20)];
        _proLabel.font = midFont;
        _proLabel.textAlignment = NSTextAlignmentCenter;
        _proLabel.text = array[i];
        [self addSubview:_proLabel];
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
