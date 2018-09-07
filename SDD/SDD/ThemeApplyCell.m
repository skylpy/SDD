//
//  ThemeApplyCell.m
//  SDD
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ThemeApplyCell.h"

@implementation ThemeApplyCell

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
        _starLable = [[UILabel alloc] init];
        _starLable.text = @"*";
        //_starLable.textColor = [SDDColor colorWithHexString:@"#FF9933"];
        _starLable.font = titleFont_15;
        _starLable.textAlignment = NSTextAlignmentCenter;
        _starLable.tag = 40;
        [self addSubview:_starLable];
        
        [_starLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
        }];
        
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nameLable];
        
        [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.left.equalTo(self.mas_left).with.offset(20);
        }];
        
        
        self.textField = [[UITextField alloc] init];
        [self.textField addTarget:self action:@selector(keyDown) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.delegate = self;
        self.textField.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(_nameLable.mas_right).with.offset(8);
        }];
        
        self.chooseLable = [[UILabel alloc] init];
        self.chooseLable.font = [UIFont systemFontOfSize:12];
        self.chooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
        
        [self addSubview:self.chooseLable];
        [_chooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(self.mas_right).with.offset(-viewWidth+80);
            make.right.equalTo(self.mas_right).with.offset(-30);
        }];
        
        self.MchooseLable = [[UILabel alloc] init];
        self.MchooseLable.font = [UIFont systemFontOfSize:12];
        self.MchooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
        
        [self addSubview:self.MchooseLable];
        [_MchooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(self.mas_right).with.offset(-viewWidth+50);
            make.right.equalTo(self.mas_right).with.offset(-30);
        }];
        
        UILabel * lineLbel = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, viewWidth-20, 1)];
        lineLbel.backgroundColor = bgColor;
        lineLbel.tag = 100;
        [self addSubview:lineLbel];
        
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}
- (void)keyDown
{
    
}
@end
