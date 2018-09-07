//
//  MyReviewTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyReviewTableViewCell.h"

@implementation MyReviewTableViewCell

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
        
        _theStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, viewWidth/3, 15) numberOfStars:5];
        _theStar.scorePercent = 0.f;
        _theStar.userInteractionEnabled = NO;           // 不评
        [self addSubview:_theStar];
        
        _theAppraise = [[UILabel alloc] init];
        _theAppraise.font = midFont;
        _theAppraise.textColor = lorangeColor;
        _theAppraise.textAlignment = NSTextAlignmentRight;
        [self addSubview:_theAppraise];
        
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
        
        [_theStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_imgView.mas_right).with.offset(12);
            make.width.mas_equalTo(viewWidth/3);
            make.height.equalTo(@15);
        }];
        
        [_theAppraise mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.height.equalTo(@15);
            make.width.equalTo(@100);
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
