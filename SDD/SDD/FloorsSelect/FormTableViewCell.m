//
//  FormTableViewCell.m
//  SDD
//
//  Created by hua on 15/9/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FormTableViewCell.h"

@implementation FormTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCellType:(CellType)cellType{
    
    self.accessoryType = UITableViewCellAccessoryNone;
    
    _theTitle = [[UILabel alloc] init];
    _theTitle.font = midFont;
    
    [self addSubview:_theTitle];
    [_theTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth/3.5, self.frame.size.height));
    }];
    
    switch (cellType) {
        case nothing:
        {
            
        }
            break;
        case withTextView:
        {
            _theSingleDetail = [[UITextField alloc] init];
            _theSingleDetail.font = midFont;
            
            [self addSubview:_theSingleDetail];
            [_theSingleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top);
                make.bottom.equalTo(self.mas_bottom);
                make.left.equalTo(_theTitle.mas_right);
                make.right.equalTo(self.mas_right).with.offset(-10);
            }];
        }
            break;
        case withLabel:
        {
            _theSelected = [[UILabel alloc] init];
            _theSelected.font = midFont;
            _theSelected.textColor = placeholder_Color;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            [self addSubview:_theSelected];
            [_theSelected mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top);
                make.bottom.equalTo(self.mas_bottom);
                make.left.equalTo(_theTitle.mas_right);
                make.right.equalTo(self.mas_right).with.offset(-10);
            }];
        }
            break;
        case withShortTextView:
        {
            
        }
            break;
        case withLongTextView:
        {
            _theMultipleDetail = [[LPlaceholderTextView alloc] init];
            _theMultipleDetail.font = midFont;
            _theMultipleDetail.placeholderColor = placeholder_Color;
            
            [self addSubview:_theMultipleDetail];
            [_theMultipleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(5);
                make.bottom.equalTo(self.mas_bottom).offset(-5);
                make.left.equalTo(_theTitle.mas_right);
                make.right.equalTo(self.mas_right).with.offset(-10);
            }];
        }
            break;
        case withUnits:
        {
            
        }
            break;
        case withIcon:
        {
            
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
