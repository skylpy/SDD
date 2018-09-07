//
//  DevCerCell.m
//  SDD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DevCerCell.h"

@implementation DevCerCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
   
    
    _textView = [[UITextView alloc] init];//WithFrame:CGRectMake(85, 13, 199, 20)
    //[_textView setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    _textView.font = [UIFont systemFontOfSize:13];
    //_textView.backgroundColor = bgColor;
    [self addSubview:_textView];
    
    
    
    _chooseLable = [[UILabel alloc] init];
    _chooseLable.font = [UIFont systemFontOfSize:13];
    _chooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
    _chooseLable.textAlignment = NSTextAlignmentRight;
    [self addSubview:_chooseLable];
    
    [_chooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(14);
        make.right.equalTo(self.mas_right).with.offset(-30);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = bgColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.height.equalTo(@1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
