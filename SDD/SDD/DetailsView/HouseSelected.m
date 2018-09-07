//
//  HouseSelected.m
//  SDD
//
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseSelected.h"

@implementation HouseSelected

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.clipsToBounds = YES;
        
        // 标题
        UILabel *online_title = [[UILabel alloc] init];
        online_title.frame = CGRectMake(8, 10, 70, 16);
        online_title.font = largeFont;
        online_title.textColor = [UIColor blackColor];
        online_title.text = @"在线选房";
        [self addSubview:online_title];
        
        UILabel *online_tips = [[UILabel alloc] init];
        online_tips.frame = CGRectMake(CGRectGetMaxX(online_title.frame)+8, 13, viewWidth-86, 10);
        online_tips.font = littleFont;
        online_tips.textColor = lgrayColor;
        online_tips.text = @"以下房源真实在售,在线缴纳定金即可锁定";
        [self addSubview:online_tips];
        
        // 左箭头
        _onLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        _onLeft.frame = CGRectMake(18, CGRectGetMaxY(online_title.frame)+15, 7, 12);
        [_onLeft setBackgroundImage:[UIImage imageNamed:@"gray_leftArrow"] forState:UIControlStateNormal];
        [self addSubview:_onLeft];
        
        // 右箭头
        _onRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _onRight.frame = CGRectMake(viewWidth-30, 17, 7, 12);
        [_onRight setBackgroundImage:[UIImage imageNamed:@"gray_rightArrow"] forState:UIControlStateNormal];
        [self addSubview:_onRight];
        
        _onlineBuilding = [[UILabel alloc] init];
        _onlineBuilding.frame = CGRectMake(40, CGRectGetMaxY(online_title.frame)+12, viewWidth-80, 18);
        _onlineBuilding.textColor = deepOrangeColor;
        _onlineBuilding.font = biggestFont;
        _onlineBuilding.text = @"A栋";
        [self addSubview:_onlineBuilding];
        
        UIView *online_detail = [[UIView alloc] init];
        online_detail.frame = CGRectMake(8, CGRectGetMaxY(_onlineBuilding.frame)+12, viewWidth-16, 20);
        online_detail.backgroundColor = bgColor;
        [self addSubview:online_detail];
        
        NSArray *ol_title = @[@"房号",@"户型",@"面积m",@"优惠价",@"操作"];
        for (int i=0; i<5; i++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(0+i*(online_detail.frame.size.width/5), 5, online_detail.frame.size.width/5, 10);
            label.font = littleFont;
            label.textColor = lgrayColor;
            label.text = ol_title[i];
            label.textAlignment = NSTextAlignmentCenter;
            [online_detail addSubview:label];
        }
        
        // 房号
        _onlineRoomNumber = [[UILabel alloc] init];
        _onlineRoomNumber.frame = CGRectMake(8, CGRectGetMaxY(online_detail.frame)+10, online_detail.frame.size.width/5, 13);
        _onlineRoomNumber.font = midFont;
        _onlineRoomNumber.textColor = deepBLack;
        _onlineRoomNumber.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_onlineRoomNumber];
        
        // 户型
        _onlineDoorModel = [[UILabel alloc] init];
        _onlineDoorModel.frame = CGRectMake(CGRectGetMaxX(_onlineRoomNumber.frame), CGRectGetMaxY(online_detail.frame)+10, online_detail.frame.size.width/5, 13);
        _onlineDoorModel.font = midFont;
        _onlineDoorModel.textColor = deepBLack;
        _onlineDoorModel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_onlineDoorModel];
        
        // 面积
        _onlineArea = [[UILabel alloc] init];
        _onlineArea.frame = CGRectMake(CGRectGetMaxX(_onlineDoorModel.frame), CGRectGetMaxY(online_detail.frame)+10, online_detail.frame.size.width/5, 13);
        _onlineArea.font = midFont;
        _onlineArea.textColor = deepBLack;
        _onlineArea.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_onlineArea];
        
        // 优惠价
        _onlinePreferentialPrice = [[UILabel alloc] init];
        _onlinePreferentialPrice.frame = CGRectMake(CGRectGetMaxX(_onlineArea.frame), CGRectGetMaxY(online_detail.frame)+10, online_detail.frame.size.width/5, 13);
        _onlinePreferentialPrice.font = midFont;
        _onlinePreferentialPrice.textColor = deepBLack;
        _onlinePreferentialPrice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_onlinePreferentialPrice];
        
        // 操作
        _onlineOperation = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlineOperation.frame = CGRectMake(CGRectGetMaxX(_onlinePreferentialPrice.frame)+8, CGRectGetMaxY(online_detail.frame)+7, online_detail.frame.size.width/5-16, 18);
        _onlineOperation.titleLabel.font = midFont;
        [_onlineOperation setTitle:@"预定" forState:UIControlStateNormal];
        [_onlineOperation setBackgroundImage:[Tools_F imageWithColor:setColor(66, 175, 30, 1) size:CGSizeMake(online_detail.frame.size.width/5-16, 17)] forState:UIControlStateNormal];
        [_onlineOperation setBackgroundImage:[Tools_F imageWithColor:lgrayColor size:CGSizeMake(online_detail.frame.size.width/5-16, 17)] forState:UIControlStateDisabled];
        [Tools_F setViewlayer:_onlineOperation cornerRadius:3 borderWidth:0 borderColor:[UIColor clearColor]];
        [self addSubview:_onlineOperation];
        
        return self;        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
