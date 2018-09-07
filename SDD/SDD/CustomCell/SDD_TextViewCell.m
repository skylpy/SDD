//
//  SDD_TextViewCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_TextViewCell.h"
#import "SDDColor.h"
@implementation SDD_TextViewCell

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
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 80, 13)];
        self.label.text = @"招商政策:";
        self.label.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.label];
        
        self.textView = [[LPlaceholderTextView alloc] initWithFrame:CGRectMake(85, 7, 250, 74) ];
        self.textView.placeholderColor = [SDDColor colorWithHexString:@"#999999"];
        self.textView.font = [UIFont systemFontOfSize:12];
        self.textView.placeholderText = @"请输入招商政策";
    
        [self addSubview:self.textView];
    }
    return self;
}

@end
