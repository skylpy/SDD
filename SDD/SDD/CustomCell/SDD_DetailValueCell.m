//
//  SDD_DetailValueCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_DetailValueCell.h"
#import "SDDColor.h"
@implementation SDD_DetailValueCell

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
        _starLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 15, 15)];
        _starLable.text = @"*";
        _starLable.textColor = [SDDColor colorWithHexString:@"#FF9933"];
        _starLable.textAlignment = NSTextAlignmentRight;
        _starLable.tag = 40;
        [self addSubview:_starLable];
        
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 80, 13)];
        self.nameLable.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.nameLable];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 8, 199, 28)];
        [self.textField addTarget:self action:@selector(keyDown) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.delegate = self;
        self.textField.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.textField];
        
        self.chooseLable = [[UILabel alloc] init];
        self.chooseLable.font = [UIFont systemFontOfSize:13];
        self.chooseLable.textColor = [SDDColor colorWithHexString:@"#999999"];
        self.chooseLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.chooseLable];
        
        [self.chooseLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.right.equalTo(self.mas_right).with.offset(-30);
            //make.right.equalTo(self.mas_right).with.offset(-10);
            
        }];
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
