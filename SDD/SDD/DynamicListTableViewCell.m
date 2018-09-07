//
//  DynamicListTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DynamicListTableViewCell.h"

@implementation DynamicListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _listImage = [[UIImageView alloc] init];
        _listImage.clipsToBounds = YES;
        _listImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_listImage];
        
        // 品牌名
        _listTitle = [[UILabel alloc] init];
        _listTitle.textColor = [UIColor blackColor];
        _listTitle.font = midFont;
        [self addSubview:_listTitle];
        
        _listSummary = [[UILabel alloc] init];
        _listSummary.font = littleFont;
        _listSummary.textColor = lgrayColor;
        _listSummary.numberOfLines = 3;
        [self addSubview:_listSummary];
        
        [_listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.equalTo(@95);
        }];
        
        [_listTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(18);
            make.left.equalTo(_listImage.mas_right).with.offset(14);
            make.right.equalTo(self.mas_right).with.offset(-14);
            make.height.equalTo(@13);
        }];
        
        [_listSummary mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_listImage.mas_right).with.offset(14);
            make.right.equalTo(self.mas_right).with.offset(-14);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).with.offset(-18);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
