//
//  ButtonCell.m
//  SDD_CD
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    _label = [[UILabel alloc] init];//WithFrame:CGRectMake(10, -10, viewWidth-20, 90)
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:10];
    _label.textColor = [SDDColor colorWithHexString:@"#999999"];
    [self addSubview:_label];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];
    
    UIButton * conBrandBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [conBrandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    conBrandBtn.tag = 1100;
    [conBrandBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateNormal];
    
    [conBrandBtn setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateHighlighted];
    [Tools_F setViewlayer:conBrandBtn cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [self addSubview:conBrandBtn];
    
    [conBrandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.equalTo(@45);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
