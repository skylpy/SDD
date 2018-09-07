//
//  HouseLooking.m
//  SDD
//
//  Created by hua on 15/6/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseLooking.h"

@implementation HouseLooking

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        _lookingHouse = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookingHouse.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_lookingHouse];
        [_lookingHouse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _lookingHouseJoin = [[UILabel alloc] init];
        _lookingHouseJoin.textColor = [UIColor blackColor];
        _lookingHouseJoin.font = largeFont;
        
        [_lookingHouse addSubview:_lookingHouseJoin];
        [_lookingHouseJoin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.left.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-100, 16));
        }];
        
        _lookingHouseTime = [[UILabel alloc] init];
        _lookingHouseTime.textColor = lgrayColor;
        _lookingHouseTime.font = midFont;
        
        [_lookingHouse addSubview:_lookingHouseTime];
        [_lookingHouseTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.left.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-100, 13));
        }];
        
        
        UIImageView *houseLookingImageView = [[UIImageView alloc] init];
        houseLookingImageView.image = [UIImage imageNamed:@"house_bus"];
        [_lookingHouse addSubview:houseLookingImageView];
        [houseLookingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(_lookingHouse.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return self;
}

@end
