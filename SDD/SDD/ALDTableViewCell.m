//
//  ALDTableViewCell.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ALDTableViewCell.h"

@implementation ALDTableViewCell{
    
    UILabel *saleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 户型图
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(10, 10, 110, 80);
        [Tools_F setViewlayer:_imgView cornerRadius:0 borderWidth:1 borderColor:ldivisionColor];
        [self addSubview:_imgView];
        
        // 户型
        _houseType = [[UILabel alloc] init];
        _houseType.frame = CGRectMake(CGRectGetMaxX(_imgView.frame)+10, 15, viewWidth-30-110, 20);
        _houseType.font = largeFont;
        _houseType.textColor = mainTitleColor;
        [self addSubview:_houseType];
        
        // 面积
        _houseSize = [[UILabel alloc] init];
        _houseSize.frame = CGRectMake(CGRectGetMaxX(_imgView.frame)+10, CGRectGetMaxY(_houseType.frame)+5, viewWidth-30-110, 15);
        _houseSize.font = midFont;
        _houseSize.textColor = lgrayColor;
        [self addSubview:_houseSize];
        
        // 业态
        _houseIndustry = [[UILabel alloc] init];
        _houseIndustry.frame = CGRectMake(CGRectGetMaxX(_imgView.frame)+10, CGRectGetMaxY(_houseSize.frame)+5, viewWidth-30-110, 15);
        _houseIndustry.font = midFont;
        _houseIndustry.textColor = lgrayColor;
        [self addSubview:_houseIndustry];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
