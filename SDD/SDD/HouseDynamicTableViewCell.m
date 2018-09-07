//
//  HouseDynamicTableViewCell.m
//  SDD
//
//  Created by hua on 15/4/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseDynamicTableViewCell.h"

@implementation HouseDynamicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _theTitle = [[UILabel alloc] init];
        _theTitle.frame = CGRectMake(10, 15, viewWidth-20, 13);
        _theTitle.textColor = dblueColor;
        _theTitle.font =  [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [self addSubview:_theTitle];
        
        _theContent = [[UILabel alloc] init];
        _theContent.frame = CGRectMake(10, CGRectGetMaxY(_theTitle.frame)+3, viewWidth-20, 60);
        _theContent.textColor = deepBLack;
        _theContent.lineBreakMode = NSLineBreakByCharWrapping;
        _theContent.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _theContent.numberOfLines = 0;
        [self addSubview:_theContent];
        
        _theTime = [[UILabel alloc] init];
        _theTime.frame = CGRectMake(10, CGRectGetMaxY(_theContent.frame)+6, viewWidth-20, 10);
        _theTime.textColor = lgrayColor;
        _theTime.font = [UIFont systemFontOfSize:15];
        [self addSubview:_theTime];
        
        _openDynamic = [UIButton buttonWithType:UIButtonTypeCustom];
        _openDynamic.frame = CGRectMake(viewWidth/2-6, CGRectGetMaxY(_theTime.frame)+2, 12, 7);
        [_openDynamic setBackgroundImage:[UIImage imageNamed:@"向下-图标"] forState:UIControlStateNormal];
        [self addSubview:_openDynamic];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
