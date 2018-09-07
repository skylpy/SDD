//
//  MyPublishTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/4.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyPublishTableViewCell.h"

@implementation MyPublishTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        // 发布状态
        UILabel *statusTitle = [[UILabel alloc] init];
        statusTitle.textColor = [UIColor blackColor];
        statusTitle.font = midFont;
        statusTitle.text = @"发布状态:";
        [self addSubview:statusTitle];
        
        _publishStatus = [[UILabel alloc] init];
        _publishStatus.textColor = [SDDColor colorWithHexString:@"#ffa700"];
        _publishStatus.font = midFont;
        _publishStatus.textAlignment = NSTextAlignmentRight;
        [self addSubview:_publishStatus];
        
        UIView *cutoff = [[UIView alloc] init];
        cutoff.backgroundColor = divisionColor;
        [self addSubview:cutoff];
        
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
        
        [statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(65, 30));
        }];
        
        [_publishStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(65, 30));
        }];
        
        [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(statusTitle.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
        }];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutoff.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.equalTo(@100);
        }];
        
        [_brankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutoff.mas_bottom).with.offset(15);
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
    }
    return self;
}

// 未通过
- (void)setIsNotPass:(BOOL)isNotPass{
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
