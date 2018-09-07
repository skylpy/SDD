//
//  VerifyRentCell.m
//  SDD
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "VerifyRentCell.h"

@implementation VerifyRentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *starLable = [[UILabel alloc] init];
        starLable.text = @"*";
        starLable.textColor = [UIColor orangeColor];
        starLable.textAlignment = NSTextAlignmentRight;
        starLable.tag = 300;
        [self addSubview:starLable];
        
        [starLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(self.mas_left).with.offset(16);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.nameLable];
        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(self.mas_left).with.offset(25);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];

        
        self.textField = [[UITextField alloc] init];
        self.textField.font = [UIFont systemFontOfSize:12];
        self.textField.tag = 1000;
        [self addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(_nameLable.mas_right).with.offset(10);
            make.width.equalTo(@200);
            
        }];
        
        UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, viewWidth, 1)];
        lineImageView.image = [UIImage imageNamed:@"line"];
        [self addSubview:lineImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
