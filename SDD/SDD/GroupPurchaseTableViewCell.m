//
//  GroupPurchaseTableViewCell.m
//  sdd_iOS_personal
//
//  Created by hua on 15/4/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "GroupPurchaseTableViewCell.h"

#import "Tools_F.h"

@implementation GroupPurchaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 图片
        _placeImage = [[UIImageView alloc] init];
        _placeImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_placeImage];
        
        // 状态
        _statusLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusLabel.titleLabel.font = titleFont_15;
        [_statusLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_statusLabel setTitle:@"进行中" forState:UIControlStateNormal];
        [_statusLabel setTitle:@"已结束" forState:UIControlStateDisabled];
        [_statusLabel setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(1, 1)]
                                forState:UIControlStateNormal];
        [_statusLabel setBackgroundImage:[Tools_F imageWithColor:ldivisionColor size:CGSizeMake(1, 1)]
                                forState:UIControlStateDisabled];
        [self addSubview:_statusLabel];
        
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
        
        // 优惠
        _placePriBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_placePriBtn setTitleColor:dblueColor forState:UIControlStateNormal];
        _placePriBtn.titleLabel.font = midFont;
        [_placePriBtn setTitle:@"独家加盟政策" forState:UIControlStateNormal];
        _placePriBtn.layer.cornerRadius = 5;
        _placePriBtn.clipsToBounds = YES;
        _placePriBtn.layer.borderWidth = 0.8;
        _placePriBtn.layer.borderColor = dblueColor.CGColor;
        _placePriBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_placePriBtn];
        
        // 独享
        _privateLabel = [[UILabel alloc] init];
        _privateLabel.textColor = dblueColor;
        _privateLabel.backgroundColor = [UIColor whiteColor];
        _privateLabel.font = bottomFont_12;
        _privateLabel.textAlignment = NSTextAlignmentCenter;
        _privateLabel.text = @"额外";
        [Tools_F setViewlayer:_privateLabel cornerRadius:3 borderWidth:1 borderColor:dblueColor];
        [self addSubview:_privateLabel];
        
        [_placeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.equalTo(@110);
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(60, 30));
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
        
        [_placePrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(_placeImage.mas_right).offset(10);
            make.right.equalTo(_teamImg.mas_left);
            make.height.equalTo(@20);
        }];
        
        [_placePriBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(_placeImage.mas_right).offset(10);
            //make.right.equalTo(_teamImg.mas_left);
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
}

- (void)setCellType:(CellType)cellType{
    
    _teamImg.hidden = YES;
    _statusLabel.hidden = YES;
    _privateLabel.hidden = YES;
    _placeDiscount.hidden = YES;
    _placePrice.hidden = YES;
    _placePriBtn.hidden = YES;
    _placeAdd.numberOfLines = 0;
    
    [_placeImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(@110);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [_teamImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_placeTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(_placeImage.mas_right).offset(10);
        make.right.equalTo(_teamImg.mas_left);
        make.height.equalTo(@20);
    }];
    
    [_placeAdd mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_placeTitle.mas_bottom);
        make.left.equalTo(_placeImage.mas_right).offset(10);
        make.right.equalTo(_teamImg.mas_left);
        make.height.equalTo(@20);
    }];
    
    [_placeDiscount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_placeAdd.mas_bottom);
        make.left.equalTo(_placeImage.mas_right).offset(10);
        make.right.equalTo(_teamImg.mas_left);
        make.height.equalTo(@20);
    }];
    
    [_placePrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(_placeImage.mas_right).offset(10);
        make.right.equalTo(_teamImg.mas_left);
        make.height.equalTo(@20);
    }];
    
    [_placePriBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(_placeImage.mas_right).offset(10);
        //make.right.equalTo(_teamImg.mas_left);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    switch (cellType) {
        case index_gp:
        {
            _teamImg.hidden = NO;
            _privateLabel.hidden = NO;
            _placeDiscount.hidden = NO;
            _placePrice.hidden = NO;
        }
            break;
        case index_gr:
        {
            _teamImg.hidden = NO;
            _privateLabel.hidden = NO;
            _placeDiscount.hidden = NO;
            _placePrice.hidden = NO;
            
            _placePrice.textColor = dblueColor;
            _placePrice.font = midFont;
            
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
            break;
        case index_hr:
        {
            _teamImg.hidden = NO;
            _placeDiscount.hidden = NO;
            _placePrice.hidden = NO;
            _placeDiscount.textColor = lblueColor;
            _placePrice.textColor = lblueColor;
            _placePrice.font = bottomFont_12;
            _placePriBtn.hidden = NO;
            _placePriBtn.titleLabel.font = bottomFont_12;
        }
            break;
        case index_dy:
        {
            _placeAdd.numberOfLines = 3;
            
            [_placeAdd mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_placeTitle.mas_bottom).offset(8);
                make.left.equalTo(_placeImage.mas_right).offset(10);
                make.right.equalTo(_teamImg.mas_left);
                make.height.greaterThanOrEqualTo(@20);
            }];
        }
            break;
        case index_gr_noPreferential:
        {
            //_teamImg.hidden = NO;
            _placeDiscount.hidden = NO;
            _placePrice.hidden = NO;
            
            _placePrice.textColor = lblueColor;
            _placePrice.font = bottomFont_12;
            
            [_placePrice mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-10);
                make.left.equalTo(_placeImage.mas_right).offset(10);
                make.right.equalTo(_teamImg.mas_left);
                make.height.equalTo(@20);
            }];
        }
            break;
        case personal_activities:
        {
            _statusLabel.hidden = NO;
            _placeDiscount.hidden = NO;
            _placeDiscount.numberOfLines = 2;
            
            [_placeDiscount mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_placeAdd.mas_bottom);
                make.left.equalTo(_placeImage.mas_right).offset(10);
                make.right.equalTo(_teamImg.mas_left);
                make.height.greaterThanOrEqualTo(@20);
            }];   
        }
            break;
        case perchase_shop:
        {
        
            _statusLabel.hidden = YES;
            _teamImg.hidden = YES;
            _placePrice.hidden = NO;
            _placePriBtn.hidden = YES;
            _placeDiscount.hidden = NO;
            _placePrice.font = bottomFont_12;
            
            _rentalLabel = [[UILabel alloc] init];
            _rentalLabel.font = bottomFont_12;
            _rentalLabel.textColor = lgrayColor;
            [self addSubview:_rentalLabel];
            [_rentalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.mas_top).with.offset(10);
                make.right.equalTo(self.mas_right).with.offset(-10);
                
            }];
        }
            break;
    }
}
- (void)setIsRecommend:(BOOL)isRecommend{
    
    _teamImg.hidden = isRecommend?NO:YES;
    _placePriBtn.hidden = isRecommend?NO:YES;
    _placePrice.hidden = isRecommend?YES:NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
