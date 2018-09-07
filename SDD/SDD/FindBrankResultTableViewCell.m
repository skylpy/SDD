//
//  FindBrankResultTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/4.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FindBrankResultTableViewCell.h"

@implementation FindBrankResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
        
        // 品牌名
        _contacterName = [[UILabel alloc] init];
        _contacterName.textColor = [UIColor blackColor];
        _contacterName.font = largeFont;
        [self addSubview:_contacterName];
        
        _region = [[UILabel alloc] init];
        _region.font = midFont;
        _region.textColor = lgrayColor;
        [self addSubview:_region];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.equalTo(@50);
        }];
        
        [_contacterName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(18);
            make.left.equalTo(_imgView.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(@16);
        }];
        
        [_region mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-18);
            make.left.equalTo(_imgView.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.equalTo(@13);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
