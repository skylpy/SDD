//
//  ReservationTableViewCell.m
//  SDD
//
//  Created by hua on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ReservationTableViewCell.h"

@implementation ReservationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *top_bg = [[UIView alloc] init];
        top_bg.backgroundColor = bgColor;
        [self addSubview:top_bg];
        
        [top_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 85/2));
        }];
        
        UIImageView * timeImageView = [[UIImageView alloc] init];
        timeImageView.image = [UIImage imageNamed:@"iconfont_rili@2x"];
        [top_bg addSubview:timeImageView];
        [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_top).with.offset(15);
            make.left.equalTo(top_bg.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _reservationTime = [[UILabel alloc] init];
        _reservationTime.textColor = lgrayColor;
        _reservationTime.font = titleFont_15;
        [top_bg addSubview:_reservationTime];
        [_reservationTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_top).with.offset(15);
            make.left.equalTo(timeImageView.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-45, 15));
        }];
        
        _houseName = [[UILabel alloc] init];
        _houseName.font = titleFont_15;
        _houseName.textColor = mainTitleColor;
        _houseName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_houseName];
        [_houseName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 45));
        }];
        
        // 分割线
        UIView *cutoff = [[UIView alloc] init];
        cutoff.backgroundColor = ldivisionColor;
        [self addSubview:cutoff];
        [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_houseName.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 1));
        }];

        _appointmentNum = [[UILabel alloc] init];
        _appointmentNum.font = midFont;
        _appointmentNum.textColor = mainTitleColor;
        [self addSubview:_appointmentNum];
        [_appointmentNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutoff.mas_bottom).with.offset(15);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
        }];
        
        _discountContent = [[UILabel alloc] init];
        _discountContent.font = midFont;
        _discountContent.textColor = tagsColor;
        [self addSubview:_discountContent];
        [_discountContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_appointmentNum.mas_bottom).with.offset(15);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
        }];
        
        // 分割线
        UIView *cutoff1 = [[UIView alloc] init];
        cutoff1.backgroundColor = ldivisionColor;
        [self addSubview:cutoff1];
        [cutoff1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_discountContent.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 1));
        }];
        
        
        _progressImage = [[UIImageView alloc] init];
        [self addSubview:_progressImage];
        [_progressImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutoff1.mas_bottom).with.offset(15);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
        }];
        
        
        NSArray * arr = @[@"预约",@"到访",@"意向金",@"签约"];
        for (int i = 0; i < 4; i ++) {
            
            _topLabel = [[UILabel alloc] init];
            _topLabel.font = midFont;
            _topLabel.text = arr[i];
            _topLabel.tag = 100+i;
            _topLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_topLabel];
            [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).with.offset(-10);
                make.left.equalTo(self.mas_left).with.offset(i*(viewWidth/4)+10);
                make.width.equalTo(@((viewWidth-90)/4));
                make.height.equalTo(@28);
            }];
            
            if (i == 0) {
                
                _topLabel.textAlignment = NSTextAlignmentLeft;
            }
            if (i == 3||i==2) {
                
                _topLabel.textAlignment = NSTextAlignmentRight;
            }
        }
        
        /* ------- */
        
        _blackShadow = [[UIView alloc] init];
        _blackShadow.backgroundColor = setColor(255, 255, 255, 0.9);
        [self addSubview:_blackShadow];
        [_blackShadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.textColor = tagsColor;
        topLabel.font = largeFont;
        topLabel.text = @"预约已经失效";
        topLabel.textAlignment = NSTextAlignmentCenter;
        
        [_blackShadow addSubview:topLabel];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@40);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 25));
        }];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.textColor = lgrayColor;
        bottomLabel.font = midFont;
        bottomLabel.text = @"预约时间已到期，点击重新预约时间";
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        
        [_blackShadow addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLabel.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
        }];
        
        _rescheduleButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                           title:@"重新预约"
                                                          target:nil
                                                          action:nil];
        _rescheduleButton.enabled = YES;
        
        [_blackShadow addSubview:_rescheduleButton];
        [_rescheduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
        }];
    }
    return self;
}

- (void)setIsOutdated:(BOOL)isOutdated{
        
    if (isOutdated) {
        
        _blackShadow.hidden = YES;
    }
    else {
        
        _blackShadow.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
