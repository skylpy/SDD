//
//  GetCouponTableViewCell.m
//  SDD
//
//  Created by hua on 15/7/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "GetCouponTableViewCell.h"

@implementation GetCouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _theTitle = [[UILabel alloc] init];
        _theTitle.font = midFont;
        
        [self addSubview:_theTitle];
        [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(18.5);
            make.left.equalTo(self.mas_left).offset(8);
            make.size.mas_equalTo(CGSizeMake(90, 13));
        }];
        
        _theTextView = [[LPlaceholderTextView alloc] init];
        _theTextView.font = midFont;
        _theTextView.backgroundColor = bgColor;
        _theTextView.contentInset = UIEdgeInsetsMake(0, 8, 0, -8);
        [Tools_F setViewlayer:_theTextView cornerRadius:4 borderWidth:0 borderColor:nil];
        
        [self addSubview:_theTextView];
        [_theTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.left.equalTo(_theTitle.mas_right);
            make.right.equalTo(self.mas_right).with.offset(-10);
        }];
        
        _theSelected = [[UILabel alloc] init];
        _theSelected.font = midFont;
        _theSelected.textColor = lgrayColor;
        _theSelected.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_theSelected];
        [_theSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.left.equalTo(_theTitle.mas_right);
            make.right.equalTo(self.mas_right).with.offset(-30);
        }];
        
    }
    return self;
}

- (void)setCellType:(CellType)cellType{
    
    _theTextView.hidden = YES;
    _theSelected.hidden = YES;
    
    switch (cellType) {
        case nothing:
        {
            
        }
            break;
        case withLabel:
        {
            _theSelected.hidden = NO;
        }
            break;
        case withShortTextView:
        {
            _theTextView.hidden = NO;
            
            [_theTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(18.5);
                make.left.equalTo(self.mas_left).offset(8);
                make.size.mas_equalTo(CGSizeMake(90, 13));
            }];
            
            [_theTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(10);
                make.bottom.equalTo(self.mas_bottom).with.offset(-10);
                make.left.equalTo(_theTitle.mas_right);
                make.width.equalTo(@100);
            }];
        }
            break;
        case withTextView:
        {
            _theTextView.hidden = NO;
        }
            break;
        case withLongTextView:
        {
            _theTextView.hidden = NO;
            
            [_theTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(18.5);
                make.left.equalTo(self.mas_left).offset(8);
                make.size.mas_equalTo(CGSizeMake(90, 13));
            }];
            
            [_theTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_theTitle.mas_bottom).offset(10);
                make.bottom.equalTo(self.mas_bottom).offset(-10);
                make.left.equalTo(self.mas_left).offset(10);
                make.right.equalTo(self.mas_right).offset(-10);
            }];
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
