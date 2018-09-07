//
//  BandMassCell.m
//  SDD
//
//  Created by mac on 15/10/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "BandMassCell.h"

@implementation BandMassCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _starLable = [[UILabel alloc] init];
        _starLable.text = @"*";
        _starLable.textColor = [UIColor orangeColor];
        _starLable.textAlignment = NSTextAlignmentRight;
        _starLable.tag = 40;
        [self addSubview:_starLable];
        
        [_starLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.left.equalTo(self.mas_left).with.offset(16);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.nameLable];
        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(13);
            make.left.equalTo(self.mas_left).with.offset(25);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        self.textField = [[UITextField alloc] init];
        self.textField.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(7);
            make.left.equalTo(_nameLable.mas_right).with.offset(10);
            make.width.equalTo(@180);
            make.height.equalTo(@30);
        }];
        
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:13];
        [self addSubview:_textView];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(8);
            make.left.equalTo(_nameLable.mas_right).with.offset(10);
            make.width.equalTo(@180);
            make.height.equalTo(@80);
        }];
        
        
        self.chooseLable = [[UILabel alloc] init];
        self.chooseLable.font = [UIFont systemFontOfSize:13];
        self.chooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
        self.chooseLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.chooseLable];
        [self.chooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-40);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, viewWidth, 1)];
        lineImageView.image = [UIImage imageNamed:@"line"];
        lineImageView.tag = 1005;
        [self addSubview:lineImageView];
        
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_receiveBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                          size:CGSizeMake(viewWidth-40, 45)]
                              forState:UIControlStateNormal];
        
        [_receiveBtn setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                          size:CGSizeMake(viewWidth-40, 45)]
                              forState:UIControlStateHighlighted];
       
        [Tools_F setViewlayer:_receiveBtn cornerRadius:5 borderWidth:0 borderColor:nil];
        [self addSubview:_receiveBtn];
        [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.centerX.equalTo(self);
            make.width.equalTo(@(viewWidth-20));
            make.height.equalTo(@45);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
