//
//  MapListCell.m
//  SDD
//
//  Created by mac on 15/11/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MapListCell.h"

@implementation MapListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 图片
        _placeImage = [[UIImageView alloc] init];
        _placeImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_placeImage];
        

        
        // 地名
        _placeTitle = [[UILabel alloc] init];
        _placeTitle.font = titleFont_15;
        _placeTitle.textColor = deepBLack;
        [self addSubview:_placeTitle];
        
        // 团购图标
        _teamImg = [[UIImageView alloc] init];
        _teamImg.image = [UIImage imageNamed:@"index_btn_rent_tag"];
        [self addSubview:_teamImg];
        
        // 地址
        _placeAdd = [[UILabel alloc] init];
        _placeAdd.textColor = lblueColor;
        _placeAdd.font = bottomFont_12;
        [self addSubview:_placeAdd];
        
        // 抵价
        _placeDiscount = [[UILabel alloc] init];
        _placeDiscount.textColor = lblueColor;
        _placeDiscount.font = bottomFont_12;
        [self addSubview:_placeDiscount];
        
        // 价格
        _placePrice = [[UILabel alloc] init];
        _placePrice.textColor = dblueColor;
        _placePrice.font = midFont;
        [self addSubview:_placePrice];
        
        // 独享
        _privateLabel = [[UILabel alloc] init];
        _privateLabel.textColor = dblueColor;
        _privateLabel.backgroundColor = [UIColor whiteColor];
        _privateLabel.font = bottomFont_12;
        _privateLabel.textAlignment = NSTextAlignmentCenter;
        _privateLabel.text = @"独享";
        [Tools_F setViewlayer:_privateLabel cornerRadius:3 borderWidth:1 borderColor:dblueColor];
        [self addSubview:_privateLabel];
        
        [_placeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.equalTo(@110);
        }];
  
        
        [_teamImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [_placeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(_placeImage.mas_right).offset(10);
            make.right.equalTo(_teamImg.mas_left);
            make.height.equalTo(@20);
        }];
        
        [_placeAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_placeTitle.mas_bottom);
            make.left.equalTo(_placeImage.mas_right).offset(10);
            make.right.equalTo(_teamImg.mas_left);
            make.height.greaterThanOrEqualTo(@20);
        }];
        
        [_placeDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_placeAdd.mas_bottom);
            make.left.equalTo(_placeImage.mas_right).offset(10);
            make.right.equalTo(_teamImg.mas_left);
            make.height.equalTo(@20);
        }];
        
        [_privateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(_placeImage.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(MULTIPLE*12*2+10, 20));
        }];
        
        [_placePrice mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_privateLabel.mas_centerY);
            make.left.equalTo(_privateLabel.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@20);
        }];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
