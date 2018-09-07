//
//  SDD_CooperationCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_CooperationCell.h"
#import "SDDColor.h"
@implementation SDD_CooperationCell

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
//        UILabel *starLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 15, 15)];
//        starLable.text = @"*";
//        starLable.textColor = [SDDColor colorWithHexString:@"#FF9933"];
//        starLable.textAlignment = NSTextAlignmentRight;
//        [self addSubview:starLable];
//        
//        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 60, 13)];
//        self.nameLable.font = [UIFont systemFontOfSize:12];
//        [self addSubview:self.nameLable];
//        
//        self.textField = [[UITextField alloc] init];
//        self.textField.font = [UIFont systemFontOfSize:12];
//        self.textField.tag = 1000;
//        //self.textField.backgroundColor = bgColor;
//        [self addSubview:self.textField];
        [self createView];
    }
    return self;
}
-(void)createView
{
    _starLable = [[UILabel alloc] init]; //WithFrame:CGRectMake(0, 16, 15, 15)
    _starLable.text = @"*";
    _starLable.textColor = [SDDColor colorWithHexString:@"#FF9933"];
    _starLable.textAlignment = NSTextAlignmentRight;
    _starLable.tag = 40;
    [self addSubview:_starLable];
    [_starLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(14);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.width.equalTo(@5);
    }];
    
    
    _nameLable = [[UILabel alloc] init];//WithFrame:CGRectMake(15, 16, 80, 13)
    _nameLable.font = [UIFont systemFontOfSize:13];
    [self addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(14);
        make.left.equalTo(_starLable.mas_right).with.offset(5);
    }];
    
    
    _textField = [[UITextField alloc] init];//WithFrame:CGRectMake(85, 13, 199, 20)
    [_textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.font = [UIFont systemFontOfSize:13];
    //_textField.backgroundColor = bgColor;
    [self addSubview:_textField];
}
@end
