//
//  MassOfDataCell.m
//  SDD
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MassOfDataCell.h"

@implementation MassOfDataCell

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
        self.nameLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nameLable];
        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.left.equalTo(self.mas_left).with.offset(25);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        self.textField = [[UITextField alloc] init];
        [self.textField addTarget:self action:@selector(keyDown) forControlEvents:UIControlEventEditingDidEndOnExit];
        //[self.textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.delegate = self;
        self.textField.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(_nameLable.mas_right).with.offset(10);
            make.width.equalTo(@180);
            
        }];

        
        self.chooseLable = [[UILabel alloc] init];
        self.chooseLable.font = [UIFont systemFontOfSize:12];
        self.chooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
        self.chooseLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.chooseLable];
        [self.chooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-40);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, viewWidth, 1)];
        lineImageView.image = [UIImage imageNamed:@"line"];
        lineImageView.tag = 1005;
        [self addSubview:lineImageView];
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
