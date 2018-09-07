//
//  MyIssueSlideView.h
//  SDD
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIssueSlideView : UIView
@property (assign) NSInteger tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;



@property (retain,nonatomic)UITableView * ProjectTableView;
@property (retain,nonatomic)UITableView * BrandTableView;
@end
