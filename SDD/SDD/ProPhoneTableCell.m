//
//  ProPhoneTableCell.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProPhoneTableCell.h"

@implementation ProPhoneTableCell

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
    _textField = [[UITextField alloc] init];
    _textField.layer.borderColor = bgColor.CGColor; // set color as you want.
    _textField.layer.borderWidth = 1.5; // set borderWidth as you want.
    _textField.layer.cornerRadius = 5;
    _textField.placeholder = @"请输入您的手机号码";
    _textField.clipsToBounds = YES;
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.equalTo(@45);
    }];
    
    _PhoneBtn = [[UIButton alloc] init];
    [_PhoneBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                       size:CGSizeMake(viewWidth-40, 45)]
                           forState:UIControlStateNormal];
    
    [_PhoneBtn setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                       size:CGSizeMake(viewWidth-40, 45)]
                           forState:UIControlStateHighlighted];
    [Tools_F setViewlayer:_PhoneBtn cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [self addSubview:_PhoneBtn];
    [_PhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.equalTo(@45);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
