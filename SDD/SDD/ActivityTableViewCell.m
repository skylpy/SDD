//
//  ActivityTableViewCell.m
//  SDD
//
//  Created by hua on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityTableViewCell.h"

#import "Tools_F.h"

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 图片
        _placeImage = [[UIImageView alloc] init];
        _placeImage.frame = CGRectMake(10, 10, viewWidth/4, 60);
        _placeImage.contentMode = UIViewContentModeScaleToFill;
        _placeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"团购缩略%d",(arc4random()%10)+1]];
        [self addSubview:_placeImage];
        
        // 地名
        _placeTitle = [[UILabel alloc] init];
        _placeTitle.frame = CGRectMake(CGRectGetMaxX(_placeImage.frame)+5, 10, viewWidth/3, 13);
        _placeTitle.font = midFont;
        _placeTitle.textColor = [UIColor blackColor];
        [self addSubview:_placeTitle];
        
        // 副标题
        _placeSubtitle = [[UILabel alloc] init];
        _placeSubtitle.frame = CGRectMake(CGRectGetMaxX(_placeImage.frame)+5, CGRectGetMaxY(_placeTitle.frame)+5, self.frame.size.width-(_placeImage.frame.size.width+20), 10);
        _placeSubtitle.textColor = lgrayColor;
        _placeSubtitle.font = littleFont;
        [self addSubview:_placeSubtitle];

        // 时间
        _placeTime = [[UILabel alloc] init];
        _placeTime.frame = CGRectMake(CGRectGetMaxX(_placeImage.frame)+5, CGRectGetMaxY(_placeSubtitle.frame)+5, viewWidth/4+10, 10);
        _placeTime.textColor = lorangeColor;
        _placeTime.font = littleFont;
        [self addSubview:_placeTime];

        // 人数
        _placePeople = [[UILabel alloc] init];
        _placePeople.frame = CGRectMake(CGRectGetMaxX(_placeTime.frame)+5, CGRectGetMaxY(_placeSubtitle.frame)+5, viewWidth/5, 10);
        _placePeople.textColor = lorangeColor;
        _placePeople.font = littleFont;
        [self addSubview:_placePeople];
        
        // 地点
        _placeAdd = [[UILabel alloc] init];
        _placeAdd.frame = CGRectMake(CGRectGetMaxX(_placeImage.frame)+5, CGRectGetMaxY(_placeTime.frame)+5, viewWidth/4+10, 10);
        _placeAdd.textColor = lorangeColor;
        _placeAdd.font = littleFont;
        [self addSubview:_placeAdd];
        
        // 已报名
        _joined = [[UILabel alloc] init];
        _joined.frame = CGRectMake(CGRectGetMaxX(_placeAdd.frame)+5, CGRectGetMaxY(_placeTime.frame)+5, viewWidth/5, 10);
        _joined.textColor = lorangeColor;
        _joined.font = littleFont;
        [self addSubview:_joined];
      
        // 右下按钮
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinButton.frame = CGRectMake(viewWidth-60, CGRectGetMaxY(_placeSubtitle.frame)+10, 50, 24);
        _joinButton.backgroundColor = lorangeColor;
        [Tools_F setViewlayer:_joinButton cornerRadius:4 borderWidth:0 borderColor:lorangeColor];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.titleLabel.font = midFont;
        [self addSubview:_joinButton];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
