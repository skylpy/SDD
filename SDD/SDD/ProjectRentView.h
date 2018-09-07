//
//  ProjectRentView.h
//  SDD
//
//  Created by mac on 15/12/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectRentView : UIView
@property (assign) NSInteger tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;



@property (retain,nonatomic)UITableView * ProceedTableView;
@property (retain,nonatomic)UITableView * CompleteTableView;
@property (retain,nonatomic)UITableView * FailureTableView;
@end
