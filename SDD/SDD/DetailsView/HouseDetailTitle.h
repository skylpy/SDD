//
//  HouseDetailTitle.h
//  SDD
//  详情页各项标题
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailTitle : UIView

typedef NS_ENUM(NSInteger, TitleType){
    
    haveArrow = 0,
    haveButton = 1,
    haveArrowWithText = 2,
};

// 标题
@property (nonatomic, strong) UILabel *theTitle;
// 下划线
@property (nonatomic, strong) UIView *cutOff;
// 标题类型
@property (nonatomic, assign) TitleType titleType;
// 选择
@property (nonatomic, strong) UISegmentedControl *segmented;
//箭头
@property (nonatomic, strong) UIImageView *arrowImgView;
@end
