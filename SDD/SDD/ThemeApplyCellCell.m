//
//  ThemeApplyCellCell.m
//  SDD
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ThemeApplyCellCell.h"

@implementation ThemeApplyCellCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
