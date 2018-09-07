//
//  JoinIndexTableViewCell.m
//  SDD
//
//  Created by hua on 15/6/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinIndexTableViewCell.h"

@implementation JoinIndexTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 图片
        _franchiseesImage = [[UIImageView alloc] init];
        _franchiseesImage.clipsToBounds = YES;
        _franchiseesImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_franchiseesImage];
        
        //优惠icon
        _preferentialLogo = [[UIImageView alloc] init];
        _preferentialLogo.contentMode = UIViewContentModeScaleAspectFill;
        _preferentialLogo.image = [UIImage imageNamed:@"icon-tip3"];
        [_franchiseesImage addSubview:_preferentialLogo];
        
        // logo
        _franchiseesLogo = [[UIImageView alloc] init];
        _franchiseesLogo.contentMode = UIViewContentModeScaleAspectFill;
        [_franchiseesImage addSubview:_franchiseesLogo];
        
        UIView *franchiseesName_bg = [[UIView alloc] init];
        franchiseesName_bg.backgroundColor = setColor(0, 0, 0, 0.6);
        [_franchiseesImage addSubview:franchiseesName_bg];
        
        // name
        _franchiseesName = [[TTTAttributedLabel alloc] init];
        _franchiseesName.font = titleFont_15;
        _franchiseesName.textColor = [UIColor whiteColor];
        [franchiseesName_bg addSubview:_franchiseesName];
        
        // 推荐
        _recommand = [[UILabel alloc] init];
        _recommand.font = bottomFont_12;//midFont;
        _recommand.textColor = [UIColor whiteColor];
        _recommand.backgroundColor = dblueColor;//tagsColor
        _recommand.text = @"独家加盟政策";//推荐  优惠
        _recommand.hidden = YES;
        _recommand.textAlignment = NSTextAlignmentCenter;
        [Tools_F setViewlayer:_recommand cornerRadius:3 borderWidth:1 borderColor:dblueColor];
        [franchiseesName_bg addSubview:_recommand];
        
        // 额度
        _investmentAmounts = [[TTTAttributedLabel alloc] init];
        _investmentAmounts.font = titleFont_15;
        _investmentAmounts.textAlignment = NSTextAlignmentCenter;
        _investmentAmounts.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        [self addSubview:_investmentAmounts];
        
        UILabel *_investmentAmounts_unit = [[UILabel alloc] init];
        _investmentAmounts_unit.font = bottomFont_12;
        _investmentAmounts_unit.textColor = lgrayColor;
        _investmentAmounts_unit.textAlignment = NSTextAlignmentCenter;
        _investmentAmounts_unit.text = @"所属行业";
        [self addSubview:_investmentAmounts_unit];
        
        UIView *cutoff_a = [[UIView alloc] init];
        cutoff_a.backgroundColor = divisionColor;
        [self addSubview:cutoff_a];
        
        // 行业
        _industry = [[TTTAttributedLabel alloc] init];
        _industry.font = titleFont_15;
        _industry.textAlignment = NSTextAlignmentCenter;
        _industry.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        [self addSubview:_industry];
        
        UILabel *_industry_unit = [[UILabel alloc] init];
        _industry_unit.font = bottomFont_12;
        _industry_unit.textColor = lgrayColor;
        _industry_unit.textAlignment = NSTextAlignmentCenter;
        _industry_unit.text =@"门店数量(约)" ;
        [self addSubview:_industry_unit];
        
        UIView *cutoff_b = [[UIView alloc] init];
        cutoff_b.backgroundColor = divisionColor;
        [self addSubview:cutoff_b];
        
        // 门店数量
        _franchiseesAmounts = [[TTTAttributedLabel alloc] init];
        _franchiseesAmounts.font = titleFont_15;
        _franchiseesAmounts.textAlignment = NSTextAlignmentCenter;
        _franchiseesAmounts.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        [self addSubview:_franchiseesAmounts];
        _franchiseesAmounts.textColor = tagsColor;
        
        _franchiseesAmounts_unit = [[UILabel alloc] init];
        _franchiseesAmounts_unit.font = bottomFont_12;
        _franchiseesAmounts_unit.textColor = lgrayColor;
        _franchiseesAmounts_unit.textAlignment = NSTextAlignmentCenter;
        _franchiseesAmounts_unit.text =@"投资额度" ;//(万)
        [self addSubview:_franchiseesAmounts_unit];
        
        // Masonry
        [_franchiseesImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 180));
        }];
        
        [_preferentialLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_top);
            make.left.equalTo(_franchiseesImage.mas_left);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            //[Tools_F setViewlayer:_franchiseesLogo cornerRadius:55/2 borderWidth:0 borderColor:nil];
        }];
        
        [_franchiseesLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_top).with.offset(10);
            make.right.equalTo(_franchiseesImage.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(55, 55));
            [Tools_F setViewlayer:_franchiseesLogo cornerRadius:55/2 borderWidth:0 borderColor:nil];
        }];
        
        [franchiseesName_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_franchiseesImage.mas_bottom);
            make.left.equalTo(_franchiseesImage.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 30));
        }];
        
        [_franchiseesName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(franchiseesName_bg);
            make.left.equalTo(franchiseesName_bg.mas_left).with.offset(10);
            make.height.equalTo(@30);
        }];
        
        [_recommand mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(franchiseesName_bg);
            //make.left.equalTo(_franchiseesName.mas_right).with.offset(10);
            make.right.equalTo(franchiseesName_bg.mas_right).with.offset(-10);
            //make.size.mas_equalTo(CGSizeMake(MULTIPLE*13*2+10, 20));
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        [_investmentAmounts mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(cutoff_a.mas_left);
            make.width.equalTo(@[_industry,_franchiseesAmounts]);
            make.height.equalTo(_investmentAmounts_unit);
        }];
        
        [_investmentAmounts_unit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_investmentAmounts.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(cutoff_a.mas_left);
            make.width.equalTo(@[_industry,_franchiseesAmounts]);
            make.height.equalTo(_investmentAmounts);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [cutoff_a mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_bottom);
            make.left.equalTo(_investmentAmounts.mas_right);
            make.right.equalTo(_industry.mas_left);
            make.width.equalTo(@1);
            make.height.equalTo(@50);
        }];
        
        [_industry mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_bottom);
            make.left.equalTo(cutoff_a.mas_right);
            make.right.equalTo(cutoff_b.mas_left);
            make.width.equalTo(@[_investmentAmounts,_franchiseesAmounts]);
            make.height.equalTo(_industry_unit);
        }];
        
        [_industry_unit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_industry.mas_bottom);
            make.left.equalTo(cutoff_a.mas_right);
            make.right.equalTo(cutoff_b.mas_left);
            make.width.equalTo(@[_investmentAmounts,_franchiseesAmounts]);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [cutoff_b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_bottom);
            make.left.equalTo(_industry.mas_right);
            make.right.equalTo(_franchiseesAmounts.mas_left);
            make.width.equalTo(@1);
            make.height.equalTo(@50);
        }];
        
        [_franchiseesAmounts mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesImage.mas_bottom);
            make.left.equalTo(cutoff_b.mas_right);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@[_industry,_investmentAmounts]);
            make.height.equalTo(_franchiseesAmounts_unit);
        }];
        
        [_franchiseesAmounts_unit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_franchiseesAmounts.mas_bottom);
            make.left.equalTo(cutoff_b.mas_right);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@[_industry,_investmentAmounts]);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (void)setIsRecommend:(BOOL)isRecommend{
    
    _recommand.hidden = isRecommend?NO:YES;
    _preferentialLogo.hidden = isRecommend?NO:YES;
}

@end
