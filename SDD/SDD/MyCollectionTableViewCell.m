//
//  MyCollectionTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyCollectionTableViewCell.h"

@implementation MyCollectionTableViewCell

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
        _brankName = [[UILabel alloc] init];
        _brankName.textColor = [UIColor blackColor];
        _brankName.font = largeFont;
        [self addSubview:_brankName];
        
        // 投资总额度
        _investmentAmountCategoryName = [[UILabel alloc] init];
        _investmentAmountCategoryName.textColor = lgrayColor;
        _investmentAmountCategoryName.font = midFont;
        [self addSubview:_investmentAmountCategoryName];
        
        // 行业类别
        _industryCategoryName = [[UILabel alloc] init];
        _industryCategoryName.textColor = lgrayColor;
        _industryCategoryName.font = midFont;
        [self addSubview:_industryCategoryName];
        
        // 门店数量
        _storeAmount = [[UILabel alloc] init];
        _storeAmount.textColor = lgrayColor;
        _storeAmount.font = midFont;
        [self addSubview:_storeAmount];
        
        // 加盟时间
        _time = [[UILabel alloc] init];
        _time.hidden = YES;
        _time.textColor = tagsColor;
        _time.font = littleFont;
        [self addSubview:_time];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.equalTo(@100);
        }];
        
        [_brankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.left.equalTo(_imgView.mas_right).with.offset(12);
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.height.equalTo(@16);
        }];
        
        [_investmentAmountCategoryName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_brankName.mas_bottom).with.offset(5);
            make.left.equalTo(_imgView.mas_right).with.offset(12);
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.height.equalTo(@13);
        }];
        
        [_industryCategoryName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_investmentAmountCategoryName.mas_bottom).with.offset(5);
            make.left.equalTo(_imgView.mas_right).with.offset(12);
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.height.equalTo(@13);
        }];
        
        [_storeAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_industryCategoryName.mas_bottom).with.offset(5);
            make.left.equalTo(_imgView.mas_right).with.offset(12);
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.height.equalTo(@13);
        }];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_brankName);
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.height.equalTo(@10);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
