//
//  FloorsSelect.h
//  SDD
//
//  Created by hua on 15/8/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloorSelectdelegate

- (void)didSelectFloor:(NSInteger)theIndex;

@end

@interface FloorsSelect : UIView

- (void)setWithFloorsName:(NSArray *)floorsName;

@property (strong, nonatomic) UIButton *topButton;
@property (strong, nonatomic) UIButton *bottomButton;
@property (assign, nonatomic) id<FloorSelectdelegate>delegate;

@end
