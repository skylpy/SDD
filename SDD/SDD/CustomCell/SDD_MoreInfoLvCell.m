//
//  SDD_MoreInfoLvCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_MoreInfoLvCell.h"
#import "SDDColor.h"
@implementation SDD_MoreInfoLvCell

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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 50, 13)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 16, 200, 13)];
        [_textField addTarget:self action:@selector(keyDown) forControlEvents:UIControlEventEditingDidEndOnExit];
        _textField.font = [UIFont systemFontOfSize:12];
        [self addSubview:_textField];
        
        UILabel *baiFen = [[UILabel alloc] initWithFrame:CGRectMake(293, 16, 16, 13)];
        baiFen.text = @"%";
        baiFen.font = [UIFont systemFontOfSize:12];
        baiFen.textColor = [SDDColor colorWithHexString:@"#999999"];
        [self addSubview:baiFen];
    }
    return self;
}
- (void)keyDown
{
    
}
@end
