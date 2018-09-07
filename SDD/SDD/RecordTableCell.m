//
//  RecordTableCell.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "RecordTableCell.h"

@implementation RecordTableCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, 20)];
    _titleLable.font = titleFont_15;
    [self addSubview:_titleLable];
    
    _lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLable.frame)+10, viewWidth, 1)];
    _lineLable.backgroundColor = bgColor;
    [self addSubview:_lineLable];
    
    _phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_lineLable.frame)+8, 100, 80)];
    _phoneImage.image = [UIImage imageNamed:@"cell_loading"];
    [self addSubview:_phoneImage];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_phoneImage.frame)+10, CGRectGetMaxY(_lineLable.frame)+15, 150, 15)];
    _timeLabel.font = midFont;
    _timeLabel.textColor = lgrayColor;
    [self addSubview:_timeLabel];
    
    _numLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_phoneImage.frame)+10, CGRectGetMaxY(_timeLabel.frame)+10, 150, 15)];
    _numLable.font = midFont;
    _numLable.textColor = lgrayColor;
    [self addSubview:_numLable];
    
    _IntegralLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_phoneImage.frame)+10, CGRectGetMaxY(_numLable.frame)+10, 150, 15)];
    _IntegralLable.font = midFont;
    _IntegralLable.textColor = lgrayColor;
    [self addSubview:_IntegralLable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
