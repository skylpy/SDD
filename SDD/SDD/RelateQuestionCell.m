//
//  RelateQuestionCell.m
//  SDD
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "RelateQuestionCell.h"

@implementation RelateQuestionCell

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
    _relateQueLabel = [[UILabel alloc] init];
    [self addSubview:_relateQueLabel];
    
    [_relateQueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, viewWidth-20, 1)];
    imageView.image = [UIImage imageNamed:@"line"];
    [self addSubview:imageView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
