//
//  SlideTabBarView.h
//  SlideTabBar
//
//  Created by Mr.LuDashi on 15/6/25.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideTabBarView : UIView

@property (assign) NSInteger tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;



@property (retain,nonatomic)UITableView * DuseTableView;
@property (retain,nonatomic)UITableView * useTableView;
@property (retain,nonatomic)UITableView * overdueTableView;

@end
